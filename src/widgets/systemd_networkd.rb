require "gtk4"
require_relative "../widgets"

# https://www.freedesktop.org/software/systemd/man/latest/org.freedesktop.network1.html

class Widgets::SystemdNetworkd < Widgets::BaseWidget
    include LowType
    using LowType::Syntax

    def initialize options
        raise "no link provided" unless options[:link]
        super
        @label = Gtk::Label.new ''
        @link_name = options[:link]
        @link_object = Widgets::SystemdNetworkd.get_link_by_name(@link_name)
        subscribe
        update_safe
        append @label
    end

    def update
      @json = get_json
      @addresses = get_addresses
      @online_state = @json["onlineState"]
      without_ll = @addresses.reject { it.start_with? "fe80" }
      @label.set_text(instance_exec(&@proc) || "#{@link_name}: #{without_ll.join(" ")}")
    end
    
    def get_json
      ::JSON.parse(@link_object["org.freedesktop.network1.Link"].Describe[0])
    end
    
    def get_addresses() -> { Array }
      @json["Addresses"].filter_map do |addr|
        case addr["Family"]
        when 2 # ipv4
          next nil if @json["IPv4AddressState"] != "routable"
          addr["Address"].join(".")
        when 10 # ipv6
          next nil if @json["IPv6AddressState"] != "routable"
          addr["Address"].each_slice(2).map { |a, b| (a << 8 | b).to_s(16) }.join(':')
        end + "/#{addr['PrefixLength']}"
      end
    end

    def subscribe
      @link_object["org.freedesktop.DBus.Properties"].on_signal("PropertiesChanged") do |iface, props, inv_props|
        puts "systemd_networkd: #{iface} changed #{props}"
        puts get_addresses.join(" ")
        if iface.to_s == "org.freedesktop.network1.Link"
          update_safe
        end
      end
      DBus.system_bus.glibize
    end

    def self.get_link_by_name(link = String) -> { DBus::ProxyObject }
      bus = DBus::SystemBus.instance
      service = bus.service("org.freedesktop.network1")
      object = service.object("/org/freedesktop/network1")
      manager = object["org.freedesktop.network1.Manager"]
      index, path = manager.GetLinkByName(link)
      service.object(path)
    end
end
