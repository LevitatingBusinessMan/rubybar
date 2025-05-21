class String
    def camelize
      split('_').collect(&:capitalize).join
    end
end

module DBus
  class Message
    ALLOW_INTERACTIVE_AUTHORIZATION = 0x4
    alias_method :original_initialize, :initialize
    def initialize(mtype=INVALID)
      original_initialize(mtype)
      @flags |= ALLOW_INTERACTIVE_AUTHORIZATION
    end
  end
end
