require "gtk4"
require_relative "../widgets"

=begin
The Load widget reads /proc/loadavg.  
Such values read like +1.28 1.18 0.92 1/2076 771310+.  
Where the first 3 values are the 5, 10 and 15m average loads.  
The fourth value is the running and total tasks (separated by a slash).  
The last value is the last pid.  

By default the load widget formats these as +"load avg: #{@short} #{@mid} #{@long}"+.
However, when a block is given it is executed with all parameters.

It is executed like
  options[:proc].call @short, @mid, @long, @running, @tasks, @last_pid

Example:
  widget :load do |short, mid, long, running, tasks| "tasks: #{running}/#{tasks}" end
  widget :load do |short| "1m avg: #{short}" end

=end
class Widgets::Load < Widgets::Widget
    def initialize options
        super
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @short, @mid, @long, tasks, @last_pid = File.read("/proc/loadavg").split
        @running, @tasks = tasks.split('/')
        # TODO consider remove these arguments, it's instance_exec'd anyway
        @label.set_text instance_exec(@short, @mid, @long, @running, @tasks, @last_pid, &@proc) || "load avg: #{@short} #{@mid} #{@long}"
    end
end
