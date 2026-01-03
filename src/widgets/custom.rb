require "gtk4"
require_relative "../widgets"

# A custom widget that executs a proc
class Widgets::Custom < Widgets::BaseWidget
    def initialize options
        super
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @label.set_text instance_eval(&@proc)
    end
end
