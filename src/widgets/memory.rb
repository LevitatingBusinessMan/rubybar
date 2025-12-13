require "gtk4"
require_relative "../widgets"

=begin
The Memory widget reads */proc/meminfo*.

By default the widget displays a precentage like: "memory: #{percentage}%"

You can make use of the instances values: @total, @available, @free, @cached and @meminfo.
The values are in KB. @meminfo is a hash containing the raw /proc/meminfo data.

Example:
  widget :memory do |_, _, _, cached| "cache: #{cached / 1_000_000}GB" end

=end
class Widgets::Memory < Widgets::Widget
    def initialize options
        super
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @meminfo = File.read('/proc/meminfo').lines.map {
          key, value = it.match(/([^:\s]): (\d)/).captures
          [key, value.to_i]
        }.to_h
        @total = @meminfo['MemTotal']
        @available = @meminfo['MemAvailable']
        @free = @meminfo['MemFree']
        @cached = @meminfo['Cached']
        percentage_used = ((@total - @available) / @total.to_f) * 100
        @label.set_text instance_exec(@total, @available, @free, @cached, &@proc) || "memory: #{percentage_used.round(0)}%"
    end
end
