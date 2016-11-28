# SeoHero

This will pull the first page results from a given search on Google. The default is to search for `seo hero` from the New York location, on Chrome, with no cookies. The intent is to provide a JSON API that will provide this data to third parties.

Current production version: 0.0.1

Current development version: 1.0.0a

## Todos

#### Version 1.0.0
- Add second page results
  - Url is: [https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8#q=seo+hero&near=new+york,new+york&start=10](https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8#q=seo+hero&near=new+york,new+york&start=10)

#### Version 1.0.1

- Server will respond to requests for data
  - ADJ: server.ex
    - Add API that returns current rankings in JSON format
- Build a test page to pull updated results
- Build a view that will handle JSON requests

#### Version 1.0.2

- Find replacement for fetch_and_delete
  - When deleting a result_collection, need to delete all the associated results

## Changelog

#### Version 1.0.0

- Removed the Phoenix logo

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
