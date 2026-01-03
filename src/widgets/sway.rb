require "gtk4"
require_relative "../widgets"
require 'socket'

# https://i3wm.org/docs/ipc.html

class WorkspaceButton < Gtk::Button # :nodoc:
  attr_accessor :id, :name
  def initialize(ws = Hash)
    @name = ws["name"]
    @id = ws["id"]
    super label: @name
    add_css_class "sway_ws_button"
    set_focused ws["focused"]
    set_urgent ws["urgent"]
    set_cursor Gdk::Cursor.new(:pointer)
  end
  
  def set_focused(focus = Boolean)
    if focus
      add_css_class "focus"
    else
      remove_css_class "focus"
    end
  end
  
  def set_urgent(urgent = Boolean)
    if urgent
      add_css_class "urgent"
    else
      remove_css_class "urgent"
    end
  end
  
end

class Widgets::Sway < Widgets::BaseWidget
  include LowType

  def initialize options
      super
      raise "sway: SWAYSOCK not defined" if !ENV["SWAYSOCK"]
      @sock = UNIXSocket.new ENV["SWAYSOCK"]
      #@mutex = Thread::Mutex.new
      
      read_loop
      get_workspaces
      subscribe_workspaces
  end

  def update
    return unless @workspaces
    # we can't sort a box, so if there is a new ws we just remove all existing children
    new_ws = !@workspaces.map { it["id"] }.all? { children.map { it.id }.include? it } 
    for child in children
      next unless child.instance_of? WorkspaceButton
      remove(child) unless !new_ws && @workspaces.map { it["id"] }.include?(child.id)
    end
    for ws in @workspaces.sort_by! { it["name"].to_i }
      if ws_button = children.find { it.id == ws["id"] }
        ws_button.set_focused ws["focused"]
        ws_button.set_urgent ws["urgent"]
        next
      end
      ws_button = WorkspaceButton.new(ws)
      ws_button.signal_connect("clicked") do
        @sock.write craft_message(type: MessageTypes::RUN_COMMAND, payload: "workspace #{it.name}")
      end
      append ws_button
    end
  end
  
  private

  module MessageTypes
    RUN_COMMAND = 0
    GET_WORKSPACES = 1
    SUBSCRIBE = 2
  end

  module EventTypes
    WORKSPACE = 0 | (1 << 31)
  end

  def craft_message(type: Integer | 0, payload: String | "") -> { String }
    "i3-ipc" + [payload.bytesize, type].pack("L<L<") + payload
  end
  
  def read_loop
    Thread.new do
      loop do
        header = @sock.read 14
        raise unless header
        magic, length, type = header.unpack("a6L<L<")
        raise unless magic == "i3-ipc"
        payload = @sock.read length
        
        case type
        when MessageTypes::RUN_COMMAND
          raise "sway: ipc command failed" unless ::JSON.parse(payload)&.first&.dig("success")
        when MessageTypes::GET_WORKSPACES
          @workspaces = ::JSON.parse(payload)
          update_safe
        when EventTypes::WORKSPACE
          get_workspaces
        else
          warn "sway: unhandled ipc type #{type}"
        end
      end
    end
  end
  
  def get_workspaces
    @sock.write craft_message(type: MessageTypes::GET_WORKSPACES)
  end
  
  def subscribe_workspaces
    @sock.write craft_message(type: MessageTypes::SUBSCRIBE, payload: ["workspace"].to_json)
  end
    
end
