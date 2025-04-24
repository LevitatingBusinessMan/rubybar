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
            update

            if options.include? :on_click
                # this doesn't work because it's a box
                #signal_connect("activate") &options[:on_click] 
            end
        end
    
        # Update method for this widget
        def update
            # nothing
        end
    
    end    
end

require_relative "widgets/uptime"
require_relative "widgets/custom"
require_relative "widgets/button"
