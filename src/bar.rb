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
    box.spacing = 10
    set_child box

    for widget in app.options[:widgets]
      pp widget if app.options[:verbose]
      case widget[:name]
      when :custom
        box.append Widgets::Custom.new widget
      else
        class_name = widget[:name].to_s.camelize
        if Widgets.const_defined? class_name
          klass = Widgets.const_get class_name
          box.append klass.new widget
        else
          puts "Unknown widget name #{widget[:name].inspect}"
        end
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
