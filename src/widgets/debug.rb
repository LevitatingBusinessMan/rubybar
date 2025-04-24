require 'debug'
require "gtk4"
require_relative "../widgets"

# Break the program and jump into debugger
class Widgets::Debug < Widgets::Widget
    def initialize options
        super        
        @button = Gtk::Button.new label: 'bye 🐛'
        @button.signal_connect("clicked") do
            return unless $stdout.isatty # doesn't work
            binding.break
        end
        append @button
    end
end
