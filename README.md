# SeoHero

This will pull the first page results from a given search on Google. The default is to search for `seo hero` from the New York location, on Chrome, with no cookies. The intent is to provide a JSON API that will provide this data to third parties.

Current version: 0.0.1ad

## Todos

#### Version 0.0.1

- Store results in repo and update state upon receiving new results
  - ADD: Result and ResultCollection models
  - ADJ: server.ex to store results upon fetch_data and update state
- Server will respond to requests for data
  - ADJ: server.ex
    - Add API that returns current rankings in JSON format
    - Add API that returns current rankings in HTML format
- Build a test page to pull updated results
- Build a view that will handle JSON requests

## Changelog

#### Version 0.0.1

- Built library to pull data from google
  - Established defaults
  - API allows for fetch_data/0, fetch_data/1, and fetch_data/3
- Added tests
  - Ensure length of results is alway 9 (always nine first page results)
  - Ensure no nil values for domain
- Built Supervisor function that is started by seo_hero.ex (i.e. on start of app)
  - ADD: server.ex
    - Server will schedule hourly result pulls via `SeoHero.Fido.fetch_data` and store in repo
    - Click [here](http://stackoverflow.com/questions/32085258/how-to-run-some-code-every-few-hours-in-phoenix-framework) for example of how to setup the schedule
  - ADD: supervisor.ex
    - Starts server.ex
  - ADJ: seo_hero.ex
    - Added `supervisor(SeoHero.Supervisor, [])` to children that are started at launch.
- Added results and result_collections tables to the Repo
