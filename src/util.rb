module RubyBar
 module Util # :nodoc:
    module StringExtensions # :nodoc:
      refine String do
        def camelize
          split('_').collect(&:capitalize).join
        end
      end
    end
  
    require 'dbus'
    module DBusExtensions # :nodoc:
      module Message # :nodoc:
        module AddInteractiveAuthFlag # :nodoc:
          ALLOW_INTERACTIVE_AUTHORIZATION = 0x4
          def initialize(mtype = DBus::Message::INVALID)
            super mtype
            @flags |= ALLOW_INTERACTIVE_AUTHORIZATION
          end
        end
      end
    end
  end
end
