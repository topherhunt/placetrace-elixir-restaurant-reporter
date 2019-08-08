defmodule Restaurants do
  # TODO: Next step would be to support dynamic filters, allowing queries like this:
  # report_on_data(filename, close_to: {target1, 2, :miles}, min_reviews: 20, min_rating: 4)
  def report_on_data(filename, [near: target, max_miles: max_miles]) do
    all_matches =
      stream_json_from_file(filename)
      |> Stream.filter(& has_lat_lng_data?(&1))
      |> Stream.filter(& miles_from(&1, target) <= max_miles)
      |> Stream.filter(& &1["review_count"] > 0)
      |> Stream.filter(& &1["rating"] >= 1)
      |> Enum.to_list()

    IO.puts "Found #{length(all_matches)} restaurants matching these constraints."
    IO.puts "\nCounts per category (note that many restaurants are in 2+ categories):\n"
    Enum.each(get_category_counts(all_matches), fn({category, count}) ->
      IO.puts " * #{category}: #{count}"
    end)
  end

  #
  # Internal helpers
  #

  defp stream_json_from_file(filename) do
    File.stream!(filename, encoding: :utf8)
    |> Stream.map(fn(line) -> Jason.decode!(line) end)
  end

  defp has_lat_lng_data?(restaurant) do
    coords = restaurant["coordinates"]
    coords["latitude"] != nil && coords["longitude"] != nil
  end

  defp miles_from(restaurant, %{lat: _, lng: _} = target) do
    this_point = %{
      lat: restaurant["coordinates"]["latitude"],
      lng: restaurant["coordinates"]["longitude"]
    }

    meters = Geocalc.distance_between(this_point, target)
    meters / 1609.344
  end

  defp get_category_counts(restaurants) do
    restaurants
    |> Enum.map(& get_categories(&1))
    |> List.flatten()
    # Now we have a flat list of category names that we can sum up
    |> Enum.reduce(%{}, fn(category, counts) ->
      old = counts[category] || 0
      Map.put(counts, category, old + 1)
    end)
    # Can sort alphabetically or by popularity
    |> Enum.sort_by(fn({_category, count}) -> 0 - count end)
  end

  defp get_categories(restaurant) do
    Enum.map(restaurant["categories"], & &1["title"])
  end
end
