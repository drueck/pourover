# Pourover

Record details about your pourovers in a structured way to help dial in
different brew methods, techniques, and beans.

## Using Locally

Start up the server with `iex -S mix` and visit the app at `localhost:4000`.

It is currently just an MVP that allows you to record a brew with some
hard-coded presets in JSON files in the data directory. Brews are stored in
`data/brews.json` and there is currently no way to view or edit them in app.

## Near Term Roadmap

- Add some kind of general rating field to quickly filter great, good, ok, bad brews
- List brews
- View brew details
- Edit brew details
- Delete brew
- Edit presets (beans, grinders, brewers, filters)
- Factor out saved beans vs bag of beans roasted on a given data
- Manage list of beans (roaster, type, name, etc)
- Manage list of current bags of beans
  - Chose a bean config from the list and add the roast date of your new bag
  - Mark a bag of beans as empty so it now longer shows in the dropdown
- Auto-calc pour weight suggestion based on water:coffee ratio presets

## Longer Term

- Query/filer brews
- Possibly switch to React + GraphQL architecture
- Store the data in the cloud rather than flat files
- Authentication
- Multi-tenancy
- Cloud deployment
