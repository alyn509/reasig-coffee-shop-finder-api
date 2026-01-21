# Overview

You have been hired by a company that builds an app for coffee addicts. You are responsible for writing a REST API that offers the possibility to take the user's coordinates and return a list of the three closest coffee shops (including distance from the user) in order from the closest to farthest.

# Data

The coffee shops are stored in a remote CSV having these columns: Name,X,Y 
The quality of data in this list of coffee shops may vary. Malformed entries should be handled appropriately.
Notice that the data file will be read from a network location (ex: https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv)

# API Response

A list of the three closest coffee shops (name, location and distance from the user) in order from the closest to farthest.
These distances should be rounded to four decimal places.
Assume all coordinates lie on a plane.

# Example

For the provided coordinates X=47.6 and Y=-122.4 the response should contain
these coffee shops:
* Starbucks Seattle2
* Starbucks Seattle
* Starbucks SF

# Running the application locally
### Prerequisites
- Elixir `~> 1.17`
- Erlang/OTP compatible with Elixir
> This project is an API-only Phoenix application and does not require Node.js or any frontend tooling.

### Environment variables

The application requires the following environment variable to be set:

``` 
export COFFEE_SHOPS_CSV_URL=https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv
```

### Setup and start

```
mix deps.get
mix phx.server
```

The server will start on:

```
http://localhost:4000 
```

### Example request

```
curl "http://localhost:4000/api/coffee-shops/nearest?x=47.58&y=-122.32"
```

### Example response

```
{
  "results": [
    {
      "name": "Starbucks Seattle",
      "y": -122.316,
      "x": 47.5809,
      "distance": 0.0041
    },
    {
      "name": "Starbucks Seattle2",
      "y": -122.3368,
      "x": 47.5869,
      "distance": 0.0182
    },
    {
      "name": "Starbucks SF",
      "y": -122.334,
      "x": 37.5209,
      "distance": 10.0591
    }
  ]
}
```

### Running tests

```
mix test
```

### Notes

- `CoffeeShopFinder.Data.DataStore` keeps an in-memory list of shops with a TTL-based cache.
- The application will fail fast on startup if `COFFEE_SHOPS_CSV_URL` is missing or invalid
- CI is configured via GitHub Actions to run tests on each push and pull request