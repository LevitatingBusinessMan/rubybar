require "gtk4"
require_relative "../widgets"

# A custom widget that executs a proc
class Widgets::Custom < Widgets::Widget
    def initialize options
        super
        @proc = options[:proc]
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @str = @proc.call
        @label.set_text @str
    end
end
