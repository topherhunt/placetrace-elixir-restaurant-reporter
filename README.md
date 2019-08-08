# Restaurants

How to run it:

  * Ensure Erlang v20+ and Elixir v1.8.1 are installed.
    - I recommend Homebrew to install Erlang then Kiex to install Elixir.
    - Cheatsheet: https://github.com/topherhunt/cheatsheets/blob/master/elixir/elixir_syntax.md#installing-elixir-on-osx

  * Clone the repo and cd into it

  * `mix deps.get`

  * `mix run scripts/report_on_restaurants.exs`

Sample output:

```
Found 5200 restaurants matching these constraints.

Counts per category (note that many restaurants are in 2+ categories):

 * Breakfast & Brunch: 521
 * Sandwiches: 503
 * Italian: 459
 * American (New): 456
 * Pizza: 396
 * Chinese: 335
 * Delis: 321
 * Bars: 312
 * American (Traditional): 294
 * Coffee & Tea: 291
 ...
 ```
