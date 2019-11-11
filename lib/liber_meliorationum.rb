# vim: set noexpandtab :miv #
# frozen_string_literal: true

# A collection of Aliases and Refinements to make life easier
module LiberMeliorationum
	# A collection of all the aliases
	module Alias
		# Aliases Enumerable#inject as fold
		module Fold
			refine Enumerable do
				alias_method :fold, :inject
			end
		end
		include Fold
		using Fold
	end
	include Alias

	# More easily convert objects to booleans
	module ToBool
		refine Object do
			def to_bool
				!!self # rubocop:disable Style/DoubleNegation
			end
		end
	end
	include ToBool

	# Apply a block or proc to an object and return its result
	module Apply
		refine Object do
			using LiberMeliorationum
			def apply(*args, &function)
				function.call(self, *args)
			end
		end
	end
	include Apply

	# Put quotes around a string
	module Quote
		refine String do
			def quote
				'"' + self + '"'
			end

			def squote
				"'" + self + "'"
			end
		end
	end
	include Quote

	# Assert whether an object is not truthy or a block returns non-truthy
	module Assert
		class AssertionFailed < StandardError; end
		refine Object do
			using LiberMeliorationum
			def assert(message = nil, error_class = AssertionFailed, &predicate)
				raise error_class, message if predicate && !instance_eval(&predicate)
				raise error_class, message if !predicate && !self

				self
			end

			def assert_not(message = nil, error_class = AssertionFailed, &predicate)
				raise error_class, message if predicate && instance_eval(&predicate)
				raise error_class, message if !predicate && self

				self
			end
		end
	end
	include Assert

	# Integration of *maybe* monads
	module Maybe
		# A maybe monad
		class Monad < BasicObject
			attr_reader :object
			def initialize(object)
				@object = object
			end

			def method_missing(sym, *args, &block)
				Maybe::Monad.new @object.send(sym, *args, &block) rescue Maybe::Monad.new nil
			end

			def respond_to_missing?(sym)
				if @object
					@object.respond_to?(sym) or super
				else
					super
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

	# Allows grouping ennumerables by a given criterion
	module EnumerableGroupBy
		refine Enumerable do
			def group_by(&criterion)
				each_with_object({}) do |entry, groups|
					(groups[criterion.call(entry)] ||= []) << entry
				end
			end
		end
	end
	include EnumerableGroupBy

	# Adds a *second* method and raising-on-nil versions of
	# - first
	# - second
	# - last
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

	# Adds an `in` method to check whether object is in a collection
	module In
		refine Object do
			def in?(ary)
				ary.respond_to? :include? and ary.include? self
			end
		end
	end
	include In

	# Allow creating pipelines from procs
	module Pipe
		# Proxy object for a list of procs
		class Proclist
			def initialize(*args)
				@procs = args
			end

			def +(other)
				self.class.new(self, other)
			end

			def <<(other)
				@procs << other
				self
			end

			def call(*args)
				@procs.each do |procedure|
					args = [procedure.call(*args)]
				end
				args.first
			end

			def self.<<(arg)
				new(arg)
			end
		end

		refine Proc do
			def +(other)
				Proclist.new(self, other)
			end
			alias_method :<<, :+
		end
	end
	using Pipe

	# Includes only the more functional modules, leaving out utilities
	module Core
		include Alias::Fold
		include ToBool
		include Apply
		include EnumerableGroupBy
		include Assert
	end
end

LiMe = LiberMeliorationum
