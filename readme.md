<!-- vim: set noexpandtab tabstop=3 :miv -->

Liber Meliorationum
================================================================================

This is a simple library that aims to make daily tasks in Ruby easier by providing refinements and aliases.

Structure
--------------------------------------------------------------------------------

-	Alias
	-	Fold
		adds a `fold` alias to `Enumerable#inject`.
-	ToBool
	adds a `to_bool` method to `Object` to avoid cryptic idioms like `!!object`.
-	Apply
	adds an `apply` method to `Object`,
	which evaluates a given block in the context of the object.
	This allows using Procs and Lambdas in a more point-free, object oriented style.
-	Maybe
	adds a *maybe* monad and a method to `object` to convert it into one.
-	Assert
	adds an `assert` method to `Object` which behaves similar to Luas `assert` function.
	It raises an error with the provided message when the provided block returns `false`.
	Otherwise returns the object itself.
-	Enumerable#group\_by(&criterion)
	Filters through the elements of an Enumerable. Calls `criterion` on every
	element and groups elements by what `criterion` returns.
	Returns a hash mapping criterion(element) => [element, element, ...]
-	EnumerableNumbered
	Adds Enumerable#second method (works as expected)
	and Enumerable#first!, #second! and #last!, which error instead of returning nil
-	In
	adds an `in? ary` method to Object which checks if the array occurs as an
	element of `ary`. If `ary` does not respond to `include?`, `false` is
	automatically returned.
-	Value
	For objects, returns the object itself.
	For arrays, returns the single value of an array or raises if the array has
	zero or more than one elements.
	For hashes, acts like for arrays, but returns the value.
-	Pipe (⚠️ Experimental)
	Allows "adding" procs to each other to chain them.
	`(a + b).call(foo)` is the same as `(b.call(a.call(foo)))`
	The `<<` operation does the same, but without creating a new object every
	time, so it's more efficient for one-liners.

Examples
--------------------------------------------------------------------------------

	using LiMe # using LiberMeliorationum

	# LiMe::Alias::Fold
	puts [1, 2, 3, 4, 5].fold {|a, b| a+b} # prints 15

	# LiMe::ToBool
	puts nil.to_bool.to_s # prints false

	# LiMe::Apply
	puts "hello".apply { |str| str.upcase } # prints HELLO

	# LiMe::Maybe
	puts [].first.even? # raises an error
	puts [].maybe.first.even?.value # prints nil

	# LiMe::Assert
	puts 20.assert('Number is not even', &:even?).to_s # prints 20
	puts 19.assert('Number is not even', &:even?).to_s # Raises an error

	# LiMe::EnumerableGroupBy
	[1, 2, 3, 4].group_by(&:even?) # returns {true => [2,4], false => [1,3]}

	# LiMe::EnumerableNumbered
	[1, 2].second # returns 2
	[1, 2].last   # returns 2
	[1].first!    # returns 1
	[].first!     # raises an error

	# LiMe::In
	20.in? [1, 2, 3] # returns false

	# LiMe::Value
	'foo'.value   # returns 'foo'
	['foo'].value # returns 'foo'
	[].value      # raises an error
	[1, 2].value  # raises an error
	{a: 'b'}      # returns 'b'

	puts 'Hello'.quote # prints "Hello"
