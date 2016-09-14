**mtb-scrape** is a project to scrape second-hand bicycle marketplace [foromtb.com](http://foromtb.com), extract data, and organize it to be easily searchable and filterable. More details [here](http://mlovic.com/projects#foromtb-scrapeprojectsforomtb-scrape).

<!--It's a collection of several parts that can be used individually. -->

<!--Unfortunately, all parts depend on ActivRecord. This is something I am trying to move away from. -->

<!--The scraper -->

<!--web app that scrapes second-hand bicycle marketplace foromtb.com, parses it, and organizes data to be easily searchable and filterable.-->

## Development

To build the project for development:

Install dependencies with bower and bundler:

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

There is also a [thor](http://whatisthor.com) CLI provided with the following commands:

    $ thor list
    mtb_cli
    -------
    thor mtb_cli:add_brand NAME    # Add new brand to the DB
    thor mtb_cli:parse_posts       # Build or update bikes from all new or updated posts
    thor mtb_cli:reparse           # Rebuild bikes from their post data
    thor mtb_cli:scrape NUM_PAGES  # Scrape the n first pages from foromtb
    thor mtb_cli:update            # Scrape last 5 pages of foromtb and update bike infor...
    thor mtb:scrape

## Contributing
Contributions are very welcome. 

For specs that require the database/ActiveRecord, require `spec_helper` and add the `loads_DB: true` RSpec metadata to the example group. If the spec can run without ActiveRecord, leave these out for faster tests!

## TODO
- Allow users to save searches and receive notifications for new bikes
- Implement submodels: 
- Abandon ActiveRecord pattern to further isolate the project's parts
- Expand scope to also track bike parts


- scheduler
- run tests
- where to download brand and model data
   
