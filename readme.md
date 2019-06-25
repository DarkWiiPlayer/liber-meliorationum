Liber Meliorationum
================================================================================

This is a simple library that aims to make daily tasks in Ruby easier by providing refinements and aliases.

Structure
--------------------------------------------------------------------------------

- Alias
	- Fold
		adds a `fold` alias to `Enumerable#inject`.
- ToBool
	adds a `to_bool` method to `Object` to avoid cryptic idioms like `!!object`.
- Apply
	adds an `apply` method to `Object`,
  which evaluates a given block in the context of the object.
  This allows using Procs and Lambdas in a more point-free, object oriented style.
- Maybe
	adds a *maybe* monad and a method to `object` to convert it into one.
- Assert
	adds an `assert` method to `Object` which behaves similar to Luas `assert` function.
  It raises an error with the provided message when the provided block returns `false`.
  Otherwise returns the object itself.
- Enumerable#group\_by(&criterion)
  Filters through the elements of an Enumerable. Calls `criterion` on every
  element and groups elements by what `criterion` returns.
  Returns a hash mapping criterion(element) => [element, element, ...]
- In
  adds an `in? ary` method to Object which checks if the array occurs as an
  element of `ary`. If `ary` does not respond to `include?`, `false` is
  automatically returned.

Examples
--------------------------------------------------------------------------------

	using LiMe # using LiberMeliorationum

	print nil.to_bool.to_s # prints false

	print "hello".apply { |str| str.upcase } # prints HELLO

	print [].first.even? # raises an error
	print [].maybe.first.even?.value # prints nil

	puts 'Hello'.quote # prints "Hello"

	puts 20.assert('Number is not even', &:even?).to_s # prints 20
	puts 19.assert('Number is not even', &:even?).to_s # Raises an error
