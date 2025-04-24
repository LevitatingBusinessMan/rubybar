require "gtk4"
require_relative "../widgets"

# A custom widget that executs a proc
class Widgets::Button < Widgets::Widget
    def initialize options
        @proc = options[:proc]
        options[:padding] ||= 10
        super
        @button = Gtk::Button.new label: @str
        append @button

        if options.include? :on_click
            @button.signal_connect("clicked") { options[:on_click].call }
        end
    end
    def update
        @str = @proc.call
    end
end
