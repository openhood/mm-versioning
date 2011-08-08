# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo_mapper/plugins/versioning/version"

Gem::Specification.new do |s|
  s.name        = "mm-versioning"
  s.version     = MongoMapper::Plugins::Versioning::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joseph HALTER", "Jonathan TRON"]
  s.email       = ["team@openhood.com"]
  s.homepage    = "http://github.com/openhood/mm-versioning"
  s.summary     = "Simple versioning for MongoMapper with proper specs"
  s.description = "Simple versioning for MongoMapper with proper specs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end