**mtb-scrape** is a project to scrape second-hand bicycle marketplace [foromtb.com](http://foromtb.com), extract data, and organize to be easily searchable and filterable. More details [here](http://mlovic.com/projects#foromtb-scrapeprojectsforomtb-scrape).

<!--It's a collection of several parts that can be used individually. -->

<!--Unfortunately, all parts depend on ActivRecord. This is something I am trying to move away from. -->

<!--The scraper -->

<!--web app that scrapes second-hand bicycle marketplace foromtb.com, parses it, and organizes data to be easily searchable and filterable.-->

## Development

To build the project for development:

Install dependencies

    bundle install
    bower install

then copy all assets to the /public directory

    rake copy_assets

and run migrations (this is a custom rake task, not Rails `rake db:migrate`)

    rake migrate

This can all be done in one step with

    rake build

### Running the code

Serve the Sinatra web app with

    ruby app.rb

There is also a [thor] CLI provided with the following commands:

    thor mtb:scrape

## Contributing
Contributions are very welcome. 

For specs that require the database/ActiveRecord, require `spec_helper` and add the `loads_DB: true` RSpec metadata to the example group. If the spec can run without ActiveRecord, leave these out for faster tests!

## TODO

boer

- scheduler
- run tests
- where to download brand and model data
