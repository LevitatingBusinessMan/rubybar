require "gtk4"
require_relative "../widgets"
require "dbus"

=begin
Show the status of a systemd unit.

[service:]
  what service?
[user:]
  user service?
=end
class Widgets::Systemd < Widgets::Widget
    def initialize options
        raise "No service provided" unless options[:service]
        options[:cursor] ||= :pointer
        super
        @unit = Widgets::Systemd.get_unit options[:service], options[:user]
        @label = Gtk::Label.new ''
        init_timer
        append @label
        @click_controller.signal_connect("pressed") { Widgets::Systemd.toggle @unit; update_safe }

        @manager = Widgets::Systemd.get_manager options[:user]
        @manager.Subscribe() rescue "systemd: Failed to subscribe"
        @manager.on_signal("JobRemoved") { |id, job, unit, result| update_safe }
        options[:user] ? DBus.session_bus.glibize : DBus.system_bus.glibize
    end

    # A function that uses a units ActiveState to return an emoji.  
    # Feel free to use this with your custom formatters!
    def self.get_status_icon unit
        case unit["ActiveState"]
        when "active" then "✅"
        when "reloading" then "⟳"
        when "failed" then "💀"
        when "inactive" then "❌"
        when "activating" then "⚡"
        when "deactivating" then "💤" # moon or zzz?
        end
    end

    def update
        @label.set_text "#{options[:service]} #{Widgets::Systemd.get_status_icon(@unit)}"
    end
    
    def self.toggle unit
        if unit["ActiveState"] == "active"
            unit.Stop "replace"
        else
            unit.Start "replace"
        end
    end

    def self.get_manager user=false
        bus = user ? DBus.session_bus : DBus.system_bus
        systemd = bus.service("org.freedesktop.systemd1")
        manager = systemd.object("/org/freedesktop/systemd1")
        
        manager.introspect
        manager["org.freedesktop.systemd1.Manager"]
    end

    def self.get_unit unit_name, user=false
        bus = user ? DBus::SessionBus.instance : DBus::SystemBus.instance
        systemd = bus.service("org.freedesktop.systemd1")
        manager = systemd.object("/org/freedesktop/systemd1")
        
        manager.introspect
        manager.default_iface = "org.freedesktop.systemd1.Manager"

        manager = self.get_manager user

        unit = systemd.object(manager.LoadUnit(unit_name).first)
        unit.introspect

        unit["org.freedesktop.systemd1.Unit"]
    end

end
