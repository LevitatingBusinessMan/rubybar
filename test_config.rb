widget :power
separated do
    widget :uptime, on_click: -> { spawn "alacritty -e htop&" }
    widget :custom,
        interval: 1,
        on_click: -> { `notify-send #{@rand}` } do
        @rand = Random.rand 100
        "random value '#{@rand}'"
    end

    separated do
        widget :button,
            on_click: -> { `notify-send hi` },
            class: "red" do
                "CLICK ME"
        end

        widget :load do |_, _, _, running| "tasks: #{running}" end
        widget :load do |short| "5m avg: #{short}" end
    end

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

    widget :debug

    widget :systemd, user: true, service: "gammastep.service"

    widget :time

    widget :load

end

css <<CSS
box.red * {
    color: red;
}
CSS
