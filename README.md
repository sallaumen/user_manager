# UserManager

#### UserManager is a simple user administrator, with the following functionalities:
 - Insert a million users at its database inserted by own project's seeds.
 - Creates an endpoint at `/` at the API, to fetch users with points above request's argument `min_number`, and also return the `timestamp` from this endpoint's last call.
 - Executes each minute at a PeriodicTask (a.k.a., CRON) to update every database User "points" value by a random number from 0 to 100.
 - This app also provides you with great logs. In case more details are needed, is possible to change the `Logger` `:level` at `/config`.

#### Installing Elixir and Erlang:

 * Make sure you have `asdf` installed
 * Run `asdf install` to install Erlang and Elixir in the correct versions. (It follows .tool-versions file)

#### Starting your database with docker:
To start the application locally, first get a postgres database running.
To do it, make sure you have docker installed, and you can use the following command at the root of the project:
- `docker-compose up`

(you might need `sudo`, depending on your machine configs)

PS: In case you don't have docker, just ensure you have postgres running and configure `/config` with your db credentials.

#### To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Run `mix run priv/repo/seeds.exs` to populate User table with 1 million entries
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

#### Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to test the API locally.

