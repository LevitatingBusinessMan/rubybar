require "gtk4_layer_shell"
require "gtk4"
require_relative "widgets"

# The Application Window
class Bar < Gtk::ApplicationWindow
  def initialize app
    super app

    set_layer_shell

    # box
    box = Gtk::Box.new :horizontal
    box.valign = :center
    box.halign = :center
    set_child box

    for widget in app.options[:widgets]
      if widget[:name] == :uptime
        box.append Widgets::Uptime.new
      end
    end
  
    # uptime
    uptime = Gtk::Label.new(`uptime`)
    box.append uptime
  
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
