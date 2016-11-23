# SeoHero

This will pull the first page results from a given search on Google. The default is to search for `seo hero` from the New York location, on Chrome, with no cookies. The intent is to provide a JSON API that will provide this data to third parties.

## Todos

#### Version 0.0.1

- Build Supervisor function that is started by seo_hero.ex (i.e. on start of app)
  - ADD: server.ex
    - Server will schedule hourly result pulls via `SeoHero.Results.get_data` and store in repo
    - Click [here](http://stackoverflow.com/questions/32085258/how-to-run-some-code-every-few-hours-in-phoenix-framework) for example of how to setup the schedule.
  - ADJ: seo_hero.ex
    - To the children section, add `supervisor(SeoHero.Supervisor, [])`

## Changelog

#### Version 0.0.1

- Built library to pull data from google
  - Established defaults
  - API allows for fetch_data/0, fetch_data/1, and fetch_data/3
- Added tests
  - Ensure length of results is alway 9 (always nine first page results)
  - Ensure no nil values for domain
- Built Supervisor function that is started by seo_hero.ex (i.e. on start of app)
  - ADD: supervisor.ex
