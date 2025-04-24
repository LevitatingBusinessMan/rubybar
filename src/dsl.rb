=begin
The configuration DSL.  
Example configuration file:
  color "red"
  widget :uptime

Using +instance_eval+ the configuration file is
executed inside the context of this class.

Please check the public methods for this class for further documentation.

=end
class DSL
  attr_reader :options

  def initialize path
    @options = {
      color: "white",
      background: "rgba(0, 0, 0, 0.5)",
      css: "",
      widgets: []
    }
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

  # Add a 
  # Example:
  #  css <<-END
  #     window.background {
  #       color: blue;
  #       background-color: red;
  #     }
  #  END
  #
  def css css
    @options[:css] = css
  end

  def widget name, options={}, &block
    @options[:widgets] << {name: name}.merge(options).merge(proc: block)
  end

end
