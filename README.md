# RubyBar

A bar for wayland implemented with Ruby and GTK.
Configuration is done via a Ruby DSL.

RubyBar is in many ways similar to.

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
