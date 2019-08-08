defmodule RestaurantsTest do
  use ExUnit.Case
  doctest Restaurants

  test "greets the world" do
    assert Restaurants.hello() == :world
  end
end
