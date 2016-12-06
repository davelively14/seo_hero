# SeoHero

This will pull results for a given search on Google. The default is to search for `seo hero` from the New York location, on Chrome, with no cookies, and return the top 20 results. The intent is to provide a JSON API that will provide this data to third parties and a simple "select-copy-paste" HTML version for those who do not want to directly connect to a service that pulls ranking from Google.

Current production version: 0.0.1

Current development version: 1.0.0a

## Todos

#### Version 1.0.0

- Added Validation
  - ADD: models/Validation.ex
    - Persisted validation results (true/false) by domain
    - Domain names must be unique

#### Version 1.1.0

- Server will respond to requests for data
  - ADJ: server.ex
    - Add API that returns current rankings in JSON format
- Build a test page to pull updated results
- Build a view that will handle JSON requests

#### Version 1.1.1

- Find replacement for fetch_and_delete
  - When deleting a result_collection, need to delete all the associated results
- Build a url generator
  - ADJ: server.ex
    - Provide search term (default: `seo hero`)
    - Provide number of results (default: 20)

## Changelog

#### Version 1.0.0

- Changed format on index
  - Aligned everything to left
- Added Validation
  - ADD: SeoHero.Validate -> ensures sites were created during a certain time period

#### Version 0.1.0

- Displayed URL used to get results
- Changed "link" alignment in table to "text-left"

#### Version 0.0.2

- Removed the Phoenix logo
- Added top 20 results

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
- Store results in repo and update state upon receiving new results
  - ADD: Result and ResultCollection models
  - ADJ: server.ex to store results upon fetch_data and update state
- Added results to main page
  - ADD: HTML formatted results
  - ADD: Textarea with HTML code
    - Selects all on focus
