require "gtk4"

DEFAULT_INTERVAL = 5

# Base Widget class.
# Defines some common behavior across top level widgets in the bar.
module Widgets
    class Widget < Gtk::Box
        # Interval with which to update this widget
        attr_accessor :interval
        
        # The options this widget was created with
        attr_reader :options

        def initialize options={}
            @options = options
			@interval = options[:interval] || DEFAULT_INTERVAL
            super :horizontal, @options[:padding] || 0
            add_css_class "barwidget"
			@css = Gtk::CssProvider.new
            style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
            
            @click_controller = Gtk::GestureClick.new
            @click_controller.button = Gdk::BUTTON_PRIMARY
            add_controller(@click_controller)

            if options.include? :on_click and not @noclick
                @click_controller.signal_connect("pressed") { options[:on_click].call }
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
    
        # Update the CSS for this widget
		# doesn't work yet?
        def css css
			@css.load_from_data css
			#style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
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
            class_name = widget[:name].to_s.camelize
            if Widgets.const_defined? class_name
              klass = Widgets.const_get class_name
			  kwidget = klass.new widget
			  kwidget.css widget[:css] if widget.include? :css
              return kwidget
            end
        end

    end    
end

require_relative "widgets/uptime"
require_relative "widgets/custom"
require_relative "widgets/button"
require_relative "widgets/power"
