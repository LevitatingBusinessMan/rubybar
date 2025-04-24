require "gtk4"

module Widgets
    class Widget < Gtk::Box
        # Interval with which to update this widget
        attr_accessor :interval
        
        # The options this widget was created with
        attr_reader :options

        def initialize options={}
            @options = options
            super :horizontal, @options[:padding] || 0
            add_css_class "barwidget"
			@css = Gtk::CssProvider.new
            style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
            update

            # click_controller = Gtk::GestureClick.new
            # click_controller = Gdk::BUTTON_PRIMARY
            # click_controller.signal_connect "pressed" do |gesture, n_press, x, y|
            # end

            if options.include? :on_click
                # this doesn't work because it's a box
                #signal_connect("clicked") &options[:on_click] 
            end
        end
    
        # Update method for this widget
        def update
            # nothing
        end
    
        # Update the CSS for this widget
		# doesn't work yet?
        def css css
			@css.load_from_data css
			#style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
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
