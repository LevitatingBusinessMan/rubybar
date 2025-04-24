require "gtk4"
require_relative "../widgets"

=begin A generic button widget
[on_click:]
  Block to execute when clicked
=end
class Widgets::Button < Widgets::Widget
    def initialize options
        @proc = options[:proc]
        @button = Gtk::Button.new label: ''
        super
        update_safe
        init_timer if options[:interval]
        append @button

        if options.include? :on_click
            @button.signal_connect("clicked") { options[:on_click].call }
        end
    end
    def update
        @button.set_label @proc.call
    end
end
