require "gtk4_layer_shell"
require "gtk4"
require_relative "widgets"
require_relative "util"

# The Application Window
class Bar < Gtk::ApplicationWindow
  def initialize app
    super app

    set_layer_shell

    # box
    box = Gtk::Box.new :horizontal
    box.valign = :center
    box.halign = :center
    box.spacing = app.options[:spacing] || 10
    box.name = "bar"
    set_child box

    for widget in app.options[:widgets]
      pp widget if app.options[:verbose]
      if klass = Widgets::Widget.from_options widget
        box.append klass
      else
        puts "Unknown widget name #{widget[:type].inspect}"
      end
    end
  end



  private
  def set_layer_shell
    Gtk4LayerShell.init_for_window(self)
    Gtk4LayerShell.auto_exclusive_zone_enable(self)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::TOP, true)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::LEFT, true)
    Gtk4LayerShell.set_anchor(self, Gtk4LayerShell::Edge::RIGHT, true)
  end

end
