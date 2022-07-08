<!-- vim: set noexpandtab tabstop=3 :miv -->

# Liber Meliorationum

A collection of general-purpose ruby refinements that aim to make everyday tasks
easier.

Examples for what everything does can be found in the code, but the code itself
should be easy enough to understand too.

## A few selected examples

Many of the refinements add helpers to make method chaining easier:

	user = User.first
		# Raise an error on missing user without breaking the method chain
		.assert("No users found")
		.assert("User has been disabled", &:disabled?)
		.assert("User is not old enough") { |user| user.age >= 18 }
		# Execute a single method on a condition
		.if(&:enabled?).disable!
		# Works well with Ruby's `tap` and `then` methods
		.if{|user| user.disabled?}.tap{|user| user.enable}
