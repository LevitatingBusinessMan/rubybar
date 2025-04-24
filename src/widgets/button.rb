require "gtk4"
require_relative "../widgets"

=begin
A generic button widget.
It currently is exactly like the custom widget
but styled as a button.
=end
class Widgets::Button < Widgets::Widget
    def initialize options
        super
        @proc = options[:proc]
        @button = Gtk::Button.new label: ''
        update_safe
        init_timer if options[:interval]
        append @button
    end
    def update
        @button.set_label @proc.call
    end
end
