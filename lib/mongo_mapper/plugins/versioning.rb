# encoding: UTF-8
module MongoMapper
  module Plugins
    module Versioning
      extend ActiveSupport::Concern

      class Version
        include ::MongoMapper::Document
        key :data, Hash
        key :original_class_name, String
        key :versioned_at, Time
        before_create :set_versioned_at
        def original
          original_class_name.constantize.from_mongo data
        end
      private
        def set_versioned_at
          self.versioned_at = Time.current.utc
        end
      end

      module ClassMethods
        def versioning(scheme=:simple, opts={})
          case scheme
          when :simple
            after_save :version_simple_save
          else
            raise ArgumentError, "unknown versioning scheme #{scheme.inspect}"
          end
          @version_class = opts[:class_name].constantize if opts[:class_name]
        end

        def version_class
          @version_class ||= ::MongoMapper::Plugins::Versioning::Version
        end
      end

      module InstanceMethods
        def version_simple_save
          version = self.class.version_class.new :data => attributes.dup
          version.original_class_name = self.class.name
          version.versioned_at = Time.current.utc
          version.save
        end
        
        def versions
          self.class.version_class.where("data._id" => id, :original_class_name => self.class.name).order :versioned_at.asc
        end
      end
    end
  end
end