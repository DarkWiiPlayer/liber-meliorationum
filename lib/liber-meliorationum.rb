module LiberMeliorationum
  module Alias
    module Fold
      refine Enumerable do
        alias :fold :inject
      end
    end
    include Fold
    using Fold
  end
  include Alias
  using Alias

# ──────────────────────────────────────────────────────────────────────────────

  module ToBool
    refine Object do
      def to_bool
        !!self
      end
    end
  end
  include ToBool
  using ToBool

# ──────────────────────────────────────────────────────────────────────────────

  module Apply
    refine Object do
      def apply(*args, &p)
        p.call(self, *args)
      end
    end
  end
  include Apply
  using Apply

# ──────────────────────────────────────────────────────────────────────────────

  module Maybe
    class Monad < BasicObject
      attr_reader :object
      def initialize(object)
        @object = object
      end
      def method_missing(sym, *args, &block)
        if @object then
          Monad.new @object.send(sym, *args, &block)
        else
          self
        end
      end
    end

    refine Object do
      def maybe
        LiberMeliorationum::Maybe::Monad.new(self)
      end
    end
  end
  include Maybe
  using Maybe

# ──────────────────────────────────────────────────────────────────────────────

  module Quote
    refine String do
      def quote
        '"'+self+'"'
      end
      def squote
        "'"+self+"'"
      end
    end
  end
  include Quote
  using Quote

# ──────────────────────────────────────────────────────────────────────────────

  module Assert
    class AssertionFailed < StandardError; end
    refine Object do
      def assert(msg=nil, &p)
        raise AssertionFailed, msg if not self.instance_eval(&p)
        self
      end
    end
  end
  include Assert
  using Assert
end

# ── ALIAS ─────────────────────────────────────────────────────────────────────

module LiMe
  include LiberMeliorationum
end
