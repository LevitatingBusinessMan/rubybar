require "gtk4"

# This module contains all the widgets and the base class Widget.
module Widgets
  DEFAULT_INTERVAL = 5

  # Base Widget class.
  # Defines some common behavior across top level widgets in the bar.
  class Widget < Gtk::Box
    # Interval with which to update this widget
    attr_accessor :interval

    # The options this widget was created with
    attr_reader :options

    def initialize options={}
      @options = options
      @interval = options[:interval] || DEFAULT_INTERVAL
      @proc = options[:proc] || Proc.new {}
      super :horizontal, @options[:padding] || 0
      add_css_class "barwidget"
      add_css_class @options[:class] if @options[:class]
      self.name = @options[:name] if @options[:name]

      @click_controller = Gtk::GestureClick.new
      @click_controller.button = Gdk::BUTTON_PRIMARY
      add_controller(@click_controller)

      if options.include? :on_click and not @noclick
        @click_controller.signal_connect("pressed") { instance_exec(&options[:on_click]) }
        set_cursor Gdk::Cursor.new(:pointer) # https://docs.gtk.org/gdk4/ctor.Cursor.new_from_name.html
      end

      if options.include? :cursor
          set_cursor Gdk::Cursor.new options[:cursor]
      end
    end

    # Update method for this widget
    def update
      # nothing
    end

  # Like update but with error handling
  def update_safe
    update
    # no error handling yet whoops
  end

		private
		def init_timer
			update_safe
			return if @interval == nil
			@timer = Thread.new {
				loop do
					sleep @interval
					update_safe
				end
			}
		end

    # Create a Widgets::Widget from a hash with options
    def self.from_options widget
      class_name = widget[:type].to_s.camelize
      if Widgets.const_defined? class_name
        klass = Widgets.const_get class_name
        kwidget = klass.new widget
        kwidget.add_css_class widget[:type]
        return kwidget
      end
    end

  end
end

require_relative "widgets/uptime"
require_relative "widgets/custom"
require_relative "widgets/button"
require_relative "widgets/power"
require_relative "widgets/load"
require_relative "widgets/separator"
require_relative "widgets/debug"
require_relative "widgets/systemd"
require_relative "widgets/time"
require_relative "widgets/memory"
