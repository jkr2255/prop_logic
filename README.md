# PropLogic

[![Build Status](https://travis-ci.org/jkr2255/prop_logic.svg?branch=master)](https://travis-ci.org/jkr2255/prop_logic)
[![Gem Version](https://badge.fury.io/rb/prop_logic.svg)](https://badge.fury.io/rb/prop_logic)

PropLogic implements propositional logic in Ruby, usable like normal variables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prop_logic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prop_logic

### Requirements
Using with CRuby, Version >= 2.0.0 is required. Doesn't work stably on 1.9.x due to unreliable behaviors on weak reference.

In JRuby and Rubinus it should work.

## Usage
### Overview
First, variables can be declared using `PropLogic.new_variable`. Next, it can be calculated using normal Ruby operators
such as `&`, `|`, `~`, and some methods. Finally, you can test satisfiability of these expressions.

```ruby
# declartion
a = PropLogic.new_variable 'a'
b = PropLogic.new_variable 'b'
c = PropLogic.new_variable 'c'

# calculation
expr1 = (a & b) | c
expr2 = ~(a.then(b))
expr3 = expr1 | expr2

# conversion
nnf = expr3.to_nnf
cnf = expr3.to_cnf
sat = expr3.sat?

# comparement
diff = (~a | ~b).equiv?(~(a & b)) # true

# assignment
(a & b).assign_true(a).assign_false(b).reduce # PropLogic::False
```

## Restriction
SAT solver bundled with this gem is brute-force solver (intended only for testing), so it is inappropriate to use for
real-scale problems.

In CRuby and Rubinius, bindings to MiniSat ([jkr2255/prop_logic-minisat](https://github.com/jkr2255/prop_logic-minisat)) is available.
It is a plugin for this gem, so no code (except require and Gemfile) needs to be changed to use `prop_logic-minisat`.

## References
`PropLogic::Term` is immutable, meaning that all calculations return new Terms.
### `PropLogic::Term` instance methods
#### `#and(*others)`, `#&(*others)`
calculate `self & others[0] & others[1] & ...`.
#### `#or(*others)`, `#|(*others)`
calculate `self | others[0] | others[1] & ...`.

#### Warning for reducing with `&` / `|`
Because of immutability and internal system of and/or terms, `many_terms.reduce(&:and)` is exteremely slow.
Use `PropLogic.all_and`/`PropLogic.all_or` or `one_term.and(*others)` to avoid this pitfall.

#### `#not()`,`#~()`, `#-@()`
calculate `Not(self)`. `#!` is not present because it confuses Ruby behavior. (if present, `!term` is always *truthy*)

#### `#then(other), #>>(other)`
caslculate `If self then other`.

#### NNF
NNF doesn't contain following terms:
- If-then
- Negation of And/Or
- Double negation

`#nnf?` checks if the term is NNF, and `#to_nnf` returns term converted to NNF.

#### Reduction
Term is regarded as reduced if:
0. it is NNF
0. it contains no constants (`PropLogic::True`/`PropLogic::False`)
0. it contains no ambivalent terms
0. it contains no duplicated terms

`#reduced?` checks if the term is reduced, and `#reduce` returns reduced term.

#### Reduction
CNF is one of these:
1. Variable and its negation
2. Logical sum of multiple 1
3. Logical product of multiple (1 or 2)

`#cnf?` checks if the term is CNF, and `#to_cnf` returns terms converted to CNF (may use extra variables).

#### SAT judgement
`#sat?` returns:
- boolean `false` if unsatisfiable
- `nil` if satisfiability is undetermined
- One term satisfying original term if satisfiable

`#unsat?` returns `true` if unsatisfiable, `false` otherwise.

#### SAT enumrator
`#each_sat` is an enumerator for all satifiabilities. Returns `Enumerator` if calling without block.

### `PropLogic` module methods
#### `PropLogic.new_variable(name = nil)`
declare new variable with name `name`. if `name` is not supplied, unique name is set.

Notice that even if the same `name` as before specified, it returns *different* variable.

#### `PropLogic.all_and(*terms)`/`PropLogic.all_or(*terms)`
calculate all and/or of `terms`. Use this when and/or calculation for many variables.

#### `PropLogic.sat_solver`/ PropLogic.sat_solver=`
set/get SAT solver object. It shoud have `#call(term)` method and return value is described in `Term#sat?`.

#### `PropLogic.incremental_solver`/ PropLogic.incremental_solver=`
set/get incremental SAT solver object. It shoud be class with `#add` and `#sat?` methods.
(see `DefaultIncrementalSolver` for its interface)

### Information
`PropLogic::Term` has some subclasses, but these classes are subject to change.
Using subclasses of `PropLogic::Term` directly is not recommended.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/prop_logic/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## ToDo

- Introduce special blocks to build terms inside
