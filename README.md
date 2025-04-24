# RubyBar

A bar for wayland implemented with Ruby and GTK.
Configuration is done via a Ruby DSL.

```RUBY
widget :power
widget :uptime
widget :custom,
    interval: 1 do
    "random value '#{Random.rand(100)}'"
end
widget :button, on_click: -> { `notify-send hi` }, css: "button label {color: red;}" do "CLICK ME" end
```

## Development
Have `gtk4_layer_shell` and `gtk4` installed for development.

```SH
GTK_DEBUG=interactive ruby src/main.rb
```
