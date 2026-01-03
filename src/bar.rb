require "gtk4_layer_shell"
require "gtk4"
require_relative "widgets"
require_relative "util"

# The Application Window
module RubyBar
  class Bar < Gtk::ApplicationWindow # :nodoc:
    def initialize app
      super app
      $bar = self
  
      set_layer_shell
  
      @center_box = Gtk::CenterBox.new
      
      @left = Gtk::Box.new :horizontal
      @left.spacing = app.options[:spacing] || 10
      @left.name = "left"
  
      @center = Gtk::Box.new :horizontal
      @center.spacing = app.options[:spacing] || 10
      @center.name = "center"
  
      @right = Gtk::Box.new :horizontal
      @right.spacing = app.options[:spacing] || 10
      @right.name = "right"
      
      @center_box.set_start_widget @left
      @center_box.set_center_widget @center
      @center_box.set_end_widget @right
      set_child @center_box
  
      for widget in app.options[:widgets]
        pp widget if app.options[:verbose]
        if (klass = Widgets::BaseWidget.from_options widget)
          case widget[:align]
          when :left
            @left.append klass
          when :right
            @right.append klass
          else
            @center.append klass
          end
        else
          puts "Unknown widget name #{widget[:type].inspect}"
        end
      end
    end
  
    # iter over the widgets
    def widgets
      [@left.children, @center.children, @right.children].flatten
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
end
