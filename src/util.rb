class String
    def camelize
      split('_').collect(&:capitalize).join
    end
end

require 'dbus'
module DBusExtensions
  module Message
    module AddInteractiveAuthFlag
      ALLOW_INTERACTIVE_AUTHORIZATION = 0x4
      def initialize(mtype=DBus::Message::INVALID)
        super mtype
        @flags |= ALLOW_INTERACTIVE_AUTHORIZATION
      end
    end
  end
end
