module LiberMeliorationum

# ── ALIAS ─────────────────────────────────────────────────────────────────────

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
			using LiberMeliorationum
      def apply(*args, &p)
        p.call(self, *args)
      end
    end
  end
  include Apply
  using Apply

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
			using LiberMeliorationum
      def assert(message=nil, error_class=AssertionFailed, &p)
        raise error_class, message if p && !self.instance_eval(&p)
        raise error_class, message if !p && !self
        self
      end
      def assert_not(message=nil, error_class=AssertionFailed, &p)
        raise error_class, message if p && self.instance_eval(&p)
        raise error_class, message if !p && self
        self
      end
    end
  end
  include Assert
  using Assert

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
			using LiberMeliorationum
      def maybe
        LiberMeliorationum::Maybe::Monad.new(self)
      end
    end
  end
  include Maybe
  using Maybe

# ──────────────────────────────────────────────────────────────────────────────

  module EnumerableGroupBy
    refine Enumerable do
      def group_by &criterion
        each_with_object({}) do
          |entry, groups|
          (groups[criterion.call(entry)] ||= []) << entry
        end
      end
    end
  end
  include EnumerableGroupBy
  using EnumerableGroupBy

# ──────────────────────────────────────────────────────────────────────────────

  module In
    refine Object do
      def in? ary
        ary.resopnd_to? :include? and ary.include? self
      end
    end
  end
  include In
  using In
end

module LiMe
  include LiberMeliorationum
end
