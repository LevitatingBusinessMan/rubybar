require "gtk4"
require_relative "../widgets"

class Widgets::Separator < Widgets::BaseWidget
    def initialize options
        super
        append Gtk::Separator.new :vertical
    end
end
