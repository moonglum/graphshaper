# Graphshaper

[![Build Status](https://secure.travis-ci.org/moonglum/graphshaper.png?branch=master)](http://travis-ci.org/moonglum/graphshaper)
[![Dependency Status](https://gemnasium.com/moonglum/graphshaper.png)](https://gemnasium.com/moonglum/graphshaper)

Graphshaper can generate realistic, scale-free graphs of any size. It is tested with MRI Ruby (1.9.2. and 1.9.3) and the 1.9 versions of jRuby and Rubinius.

## Installation

Add this line to your application's Gemfile:

    gem 'graphshaper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphshaper

## Usage

The commandline tool expects one argument: The number of vertices you want your generated graph to have. This is how to use it:

    graphshaper [options] size

You can use the following options:

* `-a`, `--arango`: Store the graph in a local ArangoDB instance
* `-l`, `--log`: Store the graph in two CSV files for nodes and edges
* `-d`, `--dot`: Store the graph in the dot format
* `-p`, `--png`: Export the graph as a PNG (you need to install graphviz for that – circo is used for the layout)
* `--version`: Show version

You can also use the library in your Ruby Code. You can find the documentation [here](http://rubydoc.info/github/moonglum/graphshaper).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes – don't forget to spec them with RSpec
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
