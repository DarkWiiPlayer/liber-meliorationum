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

# ──────────────────────────────────────────────────────────────────────────────

  module ToBool
    refine Object do
      def to_bool
        !!self
      end
    end
  end
  include ToBool

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

# ──────────────────────────────────────────────────────────────────────────────
  
  module EnumberableNumbered
    refine Enumerable do
      using Assert
      def second
        self[2]
      end
      def first!
        first.assert('Attempting to get first element of empty enumerable')
      end
      def second!
        second.assert('Attempting to get second element of empty enumerable')
      end
      def last!
        last.assert('Attempting to get last element of empty enumerable')
      end
    end
  end
  include EnumExtend

# ──────────────────────────────────────────────────────────────────────────────

  module In
    refine Object do
      def in? ary
        ary.respond_to? :include? and ary.include? self
      end
    end
  end
  include In
end

LiMe = LiberMeliorationum
