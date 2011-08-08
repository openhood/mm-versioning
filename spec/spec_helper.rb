ENV["RACK_ENV"] = "test"
require "bundler/setup"
Bundler.require :default, :test

require "mongo_mapper/plugins/versioning"

dir = File.expand_path("../../log", __FILE__)
Dir.mkdir dir unless File.directory? dir
file = File.new("#{dir}/test.log", "a")
file.sync = true
config = {"test" => {"uri" => "mongodb://localhost/mm-versioning"}}
MongoMapper.setup config, "test", {:logger => Logger.new(file)}

RSpec.configure do |config|
  config.after{ MongoMapper.database.collections.each(&:remove) }
end