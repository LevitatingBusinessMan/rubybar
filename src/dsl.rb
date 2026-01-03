require_relative "widgets"

=begin
The configuration DSL.  
Example configuration file:
  # encoding: utf-8
  widget :power
  widget :uptime, on_click: -> { spawn "alacritty -e htop&" }
  widget :custom,
      interval: 1,
      on_click: -> { `notify-send #{@rand}` } do
      @rand = Random.rand 100
      "random value '#{@rand}'"
  end

  widget :button,
    on_click: -> { `notify-send '#{self.inspect}'` },
      class: "red" do
          "CLICK ME"
  end

  widget :load do |_, _, _, running| "tasks: #{running}" end
  widget :load do |short| "5m avg: #{short}" end

  class Widgets::Spinner < Widgets::Widget
      def initialize options
          super
          init_timer
          @spinner = Gtk::Spinner.new
          append @spinner
          @spinner.start
      end
  end

  widget :spinner

  css <<CSS
  box.red * {
      color: red;
  }
  CSS

Using +instance_eval+ the configuration file is
executed inside the context of this class.

Please check the public methods for this class for further documentation.

= Entirely custom widgets
If you want a truly custom widget just make one.
This code will create a spinner in your bar:
  class Widgets::Spinner < Widgets::Widget
      def initialize options
          super
          init_timer
          @spinner = Gtk::Spinner.new
          append @spinner
          @spinner.start
      end
  end

  widget :spinner

= Styling
See DSL#css.

=== Some implementation details
The DSL produces a hash in DSL#options.  
This hash is then used to configure the bar.
This hash is printed when rubybar is run in verbose mode.

The DSL#widget method also creates a hash that can then be used by Widgets::Widget::from_options to build a Widgets::Widget.

=end
class DSL
  include Widgets
  attr_reader :options
  using RubyBar::Util::StringExtensions

  def initialize path
    @options = {
      color: "white",
      background: "rgba(0, 0, 0, 0.5)",
      css: "",
      widgets: []
    }
    @separating = []
    @align = nil
    instance_eval(File.read(path), path) if path
  end

  # The default text color.  
  # Defaults to <tt>"white"</tt>.
  def color value
    @options[:color] = value
  end

  # The window background color.  
  # Defaults to <tt>"rgba(0, 0, 0, 0.5)"</tt>.
  def background value
    @options[:background] = value
  end

  # Add custom CSS.  
  # This can be combined with the ability to configure a 
  # Widgets::Widget with a custom name and/or class
  # for setting styles for a specific widget.
  #
  # All the top-level widgets can be selected as box.barwidget.
  # 
  # Example:
  #  css <<-END
  #     box.red * {
  #       color: red;
  #     }
  #     box.load#tasks * {
  #       color: green;
  #     }
  #  END
  #
  def css css
    @options[:css] = css
  end

  # Configure a Widgets::Widget for your bar.
  def widget type, options={}, &block
    # optionally place a separator
    unless @separating.empty?
      if !@separating.last[0]
        @separating.each { it[0] = true }
      else
        @options[:widgets] << @separating.last[1].merge({type: :separator, align: @align})
      end
    end

    @options[:widgets] << options.merge({type: type, proc: block, align: @align})
  end

  # Set the spacing for the top-level box widget.  
  # All widgets will be spaced this amount apart.  
  # Default is +10+.
  def spacing spacing
    @options[:spacing] = spacing
  end

  # Place a Widgets::Separator between all widgets
  #  separated do
  #    widget :button, on_click: -> {} do "clicky click" end
  #    widget :load do |_, _, _, running| "tasks: #{running}" end
  #    widget :load do |short| "5m avg: #{short}" end
  #  end
  #
  # This doesn't stack.
  #
  # You can also set standard widget options for the separators.  
  # Just in case some crazy person wants to make all his separators clickable or something.  
  # I don't know what people are out there.
  def separated options={}
    # the first value defines if a widget has already been placed in this group
    # (to skip the first seperator)
    @separating << [false, options]
    yield
    @separating.pop
  end

  # Place a group of widgets on the left
  # 
  # Example:
  #   left {
  #     widget :sway
  #   }
  def left
    raise "cannot set align to :left, align is already set to #{align}" if @align
    @align = :left
    yield
    @align = nil
  end

  # Place a group of widgets in the center (default)
  def center
    raise "cannot set align to :center, align is already set to #{align}" if @align
    @align = :center
    yield
    @align = nil
  end

  # Place a group of widgets on the right
  # 
  # Example:
  #   right {
  #     widget :time
  #     widget :moon
  #   }
  def right
    raise "cannot set align to :center, align is already set to #{align}" if @align
    @align = :right
    yield
    @align = nil
  end
  
end
