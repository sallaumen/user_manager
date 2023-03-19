# UserManager

#### UserManager is a simple user administrator, with the following functionalities:
 - A million users at its database inserted by project's seeds.
 - A endpoint at `/` to fetch users with points above request's argument `min_number`.
 - A Periodic Task (CRON) to update every database User point by a random number from 0 to 100 each minute.

#### Installing Elixir and Erlang:

 * Make sure you have `asdf` installed
 * Run `asdf install` to install Erlang and Elixir in the correct versions. (It follows .tool-versions file)

#### To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Run `mix run priv/repo/seeds.exs` to populate User table with 1 million entries
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

#### Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to test the API locally.

