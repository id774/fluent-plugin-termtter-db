# fluent-plugin-termtter-db

Fluentd input plugin for termtter db.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-termtter-db'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-termtter-db

## Usage

1. Use termtter ( https://github.com/termtter/termtter ) with ar-single plugin.
2. Put sqlite3 database to db directory.
3. This plugin will load the data of the sqlite3 database.

### Fluentd config

    <source>
      type           termtter-db
      db_file        sqlite3.db       # The file name of sqlite3.
      tag            twitter.statuses # JSON Tag name.
      load_protected false            # Load protected tweets when true.
    </source>

### Output example

    <match termtter.statuses>
      type file
      path termtter.log
    </match>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changes

### 0.0.1

* Initial release.
