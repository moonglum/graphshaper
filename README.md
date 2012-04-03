# Graphshaper

[![Build Status](https://secure.travis-ci.org/moonglum/graphshaper.png?branch=master)](http://travis-ci.org/moonglum/graphshaper)

Graphshaper can generate realistic, scale-free graphs of any size.

## Installation

Add this line to your application's Gemfile:

    gem 'graphshaper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphshaper

## Usage

The commandline tool expects one argument: The number of nodes you want your generated graph to have. For example:

    graphshaper 50

You can also use the `Graphshaper::UndirectedGraph` class in your Rubycode. To find examples on how to do that please refer to the specs.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes – don't forget to spec them with RSpec
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
