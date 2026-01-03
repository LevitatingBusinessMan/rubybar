require 'debug'
require "gtk4"
require_relative "../widgets"

# Break the program and jump into debugger
class Widgets::Debug < Widgets::BaseWidget
    def initialize options
        super
        @button = Gtk::Button.new label: 'bye 🐛'
        @button.signal_connect("clicked") do
            binding.break if $stdout.isatty and $stdin.isatty
        end
        append @button
    end
end
