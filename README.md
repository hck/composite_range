Overview
========

composite_range is a simple class if you need to deal with more than one range at once.

Installation
============

Add this line to your application's Gemfile:

    gem 'composite_range'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install composite_range

Usage
=====

You can simply create a composite range by passing all ranges that you plan to deal with:

    range = CompositeRange.new([1..10, 12..45, 37..98])

If you have some ranges to exclude from the main one:

    range = CompositeRange.new(1..20, exclude: [3..5, 9..14])

After creating of instance, you can do the range operations: include?, cover?, begin, end, first, last.

Adding ranges dynamically:

    range << (2..12)

or

    range[] = (2..12)

Getting range by index:

    range[index]

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
