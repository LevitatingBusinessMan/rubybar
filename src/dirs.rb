module RubyBar # :nodoc:
  module Dirs # :nodoc:
    def self.tmp
      XDG::Cache.new.home
    end
  end
end
