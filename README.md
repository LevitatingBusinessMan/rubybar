# RubyBar

A bar for wayland implemented with Ruby and GTK.
Configuration is done via a Ruby DSL.

RubyBar is in many ways similar to Waybar.  
Both RubyBar and Waybar are `gtk4` applications using `gtk4-layer-shell`.
However where Waybar requires static json-like configuration files RubyBar uses a pure-ruby DSL.
The DSL allows you to configure your bar programmatically.

You can even code your own widgets.

```RUBY
widget :power
widget :uptime, on_click: -> { spawn "alacritty -e htop&" }
widget :custom,
    interval: 1,
    on_click: -> { `notify-send #{@rand}` } do
    @rand = Random.rand 100
    "random value '#{@rand}'"
end

widget :button,
    on_click: -> { `notify-send hi` },
    class: "red" do
        "CLICK ME"
end

css <<CSS
box.red * {
    color: red;
}
CSS
```

## Configuration
Configuration is primarily done via the DSL.
Please see the DSL documentation for the available methods.

## Development
Have `gtk4_layer_shell` and `gtk4` installed for development.

```SH
GTK_DEBUG=interactive ruby src/main.rb
```
