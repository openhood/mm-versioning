mm-versioning
=============

Simple versioning for MongoMapper with proper specs.

Basic Usage
-----------

```ruby
class Versioned do
  include MongoMapper::Document
  include MongoMapper::Plugins::Versioning
  key :title
  versioning
end
v = Versioned.new :title => "Alpha"
v.save!
v.versions.size # -> 1
v.update_attribute :title, "Beta"
v.versions.size # -> 2
v.versions.first.original.title # -> "Alpha"
```

Advanced Usage
--------------

See specs.

Licence
-------

This gem is released under MIT Licence.