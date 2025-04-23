require "gtk4"

module Widgets
    class Widget < Gtk::Box
        # Interval with which to update this widget
        attr_accessor :interval
    
        def initialize
            super :horizontal
            update
        end
    
        # Update method for this widget
        def update
            # nothing
        end
    
    end    
end

require_relative "widgets/uptime"
