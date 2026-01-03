require "gtk4"
require_relative "../widgets"
require "dbus"

=begin
Show the status of a systemd unit.

[service:]
  what service?
[user:]
  user service?
  
Example:
  # display collectd.service status
  widget :systemd, service: "collectd.service"

  # control gammastep as an icon
  widget :systemd, user: true, service: "gammastep.service" do
    case @unit["ActiveState"]
    when "active" then "🕯️"
    else "☀️"
    end
  end
  
=end
class Widgets::Systemd < Widgets::Widget
    def initialize options
        raise "No service provided" unless options[:service]
        options[:cursor] ||= :pointer
        super
        @unit = Widgets::Systemd.get_unit options[:service], options[:user]
        @label = Gtk::Label.new ''
        append @label
        update_safe
        @click_controller.signal_connect("pressed") { Widgets::Systemd.toggle @unit; update_safe }
        @manager = Widgets::Systemd.get_manager options[:user]
        @manager.Subscribe() rescue "systemd: Failed to subscribe"
        @manager.on_signal("JobRemoved") { |id, job, unit, result| update_safe }
        @manager.on_signal("JobNew") { |id, job, unit, result| update_safe }
        options[:user] ? DBus.session_bus.glibize : DBus.system_bus.glibize
    end

    # A function that uses a units ActiveState to return an emoji.  
    # Feel free to use this with your custom formatters!
    def self.get_status_icon unit
        case unit["ActiveState"]
        when "active" then "✅"
        when "reloading" then "⟳"
        when "failed" then "💀"
        when "inactive" then "❌"
        when "activating" then "⚡"
        when "deactivating" then "💤" # moon or zzz?
        end
    end

    def update
        @label.set_text(instance_exec(&@proc) || "#{@options[:service]} #{Widgets::Systemd.get_status_icon(@unit)}")
    end
    
    def self.toggle unit
      begin
        if unit["ActiveState"] == "active"
            unit.Stop "replace"
        else
            unit.Start "replace"
        end
      rescue => ex
        warn ex
      end
    end

    def self.get_manager user=false
        bus = user ? DBus.session_bus : DBus.system_bus
        systemd = bus.service("org.freedesktop.systemd1")
        manager = systemd.object("/org/freedesktop/systemd1")
        
        manager.introspect
        manager["org.freedesktop.systemd1.Manager"]
    end

    def self.get_unit unit_name, user=false
        bus = user ? DBus::SessionBus.instance : DBus::SystemBus.instance
        systemd = bus.service("org.freedesktop.systemd1")
        manager = systemd.object("/org/freedesktop/systemd1")
        
        manager.introspect
        manager.default_iface = "org.freedesktop.systemd1.Manager"

        manager = self.get_manager user

        unit = systemd.object(manager.LoadUnit(unit_name).first)
        unit.introspect

        unit["org.freedesktop.systemd1.Unit"]
    end

end
