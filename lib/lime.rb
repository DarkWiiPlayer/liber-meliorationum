# frozen_string_literal: true

# A collection of Aliases and Refinements to make life easier
module Lime
	# Less esoteric way to convert any value into a boolean
	# 	using LiMe::ToBool
	# 	puts 3.to_bool
	module ToBool
		refine Object do
			def to_bool
				!!self
			end
		end
	end
	include ToBool

	# Apply a block or proc to an object and return its result
	# using LiMe::Apply
	# 	10.apply(1, {|number, other| number + other})
	# 	#or:
	# 	10.apply(1, &:+)
	module Apply
		refine Object do
			def apply(*args, &function)
				function.call(self, *args)
			end
		end
	end
	include Apply

	# Surrounds a string with quotes.
	# No escaping is done if the string contains quotes already.
	# 	using LiMe::Quote
	# 	puts "Hello, World!".quote
	# 	puts "Hello, World!".squote
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

	# Assert whether an object is not truthy or a block returns non-truthy.
	# Returns the value unmodified.
	# 	using LiMe::Assert
	# 	user = nil
	# 	user.assert("Expected user to exist")
	# 	20.assert("Number must be less than 10") { |num| num < 10 }
	module Assert
		class AssertionFailed < StandardError; end
		refine Object do
			def assert(message = nil, error_class = AssertionFailed)
				raise error_class, message if block_given? && !yield(self)
				raise error_class, message if !block_given? && !self
				self
			end

			def assert_not(message = nil, error_class = AssertionFailed)
				raise error_class, message if block_given? && yield(self)
				raise error_class, message if !block_given? && self
				self
			end
		end
	end
	include Assert

	# Make sure an array or hash only has one element and return it.
	# 	users = [ User.new ]
	# 	user = users.only
	# 	users = { steve: User.new(name: 'Steve') }
	# 	user = hash.only
	module Only
		refine Hash do
			def only
				raise RuntimeError, "Expected hash to have exactly one pair" unless keys.size == 1
				self[keys.first]
			end
		end
		refine Array do
			def only
				raise RuntimeError, "Expected array to have exactly one value" unless length == 1
				first
			end
		end
	end
	include Only

	# Sorts elements into a tree according to a list of functions.
	# This is essentially a nested version of Array#group_by.
	# 	using LiMe::TreeBy
	# 	Tester = Struct.new(:foo, :bar, :baz, :name)
	# 	[
	# 		Tester.new(:a, :a, :a, "first"),
	# 		Tester.new(:a, :b, :a, "second"),
	# 		Tester.new(:b, :a, :a, "third"),
	# 	].tree_by(&:a, &:b, &:c)
	# This will split the elements as follows:
	# Hash
	# ├──:a
	# │  ├──:a
	# │  │  └──:a => first
	# │  └──:b
	# │     └──:a => second
	# └──:b
	#    └──:a
	#       └──:a => third
	module TreeBy
		refine Array do
			def tree_by(criterion, *criteria)
				group_by(&criterion.to_proc).then do |result|
					if criteria.empty?
						result
					else
						result.map{ |key, ary| [key, ary.tree_by(*criteria)] }.to_h
					end
				end
			end
		end
	end
	include TreeBy

	# Adds a *second* method and raising-on-nil versions of
	# - first
	# - second
	# - last
	# 	[:foo].second # returns nil
	# 	[:foo].second! # raises an error
	module Numbered
		refine Array do
			def second
				self[2]
			end

#			def first!
#				# TODO: Implement again
#			end
#
#			def second!
#				# TODO: Implement again
#			end
#
#			def last!
#				# TODO: Implement again
#			end
		end
	end
	include Numbered

	# Adds an `in` method to check whether object is in a collection.
	# This works on everything that responds to :include?
	# 	3.in? (1..10)
	module In
		refine Object do
			def in?(ary)
				ary.respond_to? :include? and ary.include? self
			end
		end
	end
	include In

	# Adds an `if` method to conditionally transform an object
	# Boolean and Block
	# 	20.if(true){|num| num+1} # 21
	# Boolean and chained method call
	# 	20.if(true).next # 21
	# 	20.if(false).next # 20
	# Block and chained method call
	# 	20.if{|num| num < 40}.next #21
	# 	20.if{|num| num < 10}.next #20
	module If
		class SkipNext < BasicObject
			def initialize object
				@object = object
			end
			def method_missing name, *args, **params
				return @object
			end
		end

		MISSING = Object.new

		refine Object do
			def if bool=MISSING
				if block_given?
					if yield self
						self
					else
						SkipNext.new(self)
					end
				elsif bool!=MISSING
					if bool
						self
					else
						SkipNext.new(self)
					end
				else
					self ? self : SkipNext.new(self)
				end
			end
		end
	end
	include If
end

LiberMeliorationum = Lime
