require 'pry'

module Volt
  class Migration
    class << self
      attr_accessor :migrations

      def sequence_id(new_sequence_id=nil)
        unless new_sequence_id.nil?
          @sequence_id = new_sequence_id
          if superclass.migrations.has_key?(new_sequence_id)
            raise 'Your migrations contain duplicate sequence ids'
          else
            superclass.migrations[new_sequence_id] = self
          end
        end
        @sequence_id
      end
    end
  end
  Migration.migrations = {}

  class Migrator
    def initialize(thor, options={})
      @thor = thor
    end

    def migrate!
      if current_sequence_id == latest_sequence_id
        @thor.say("Migrations are all up to date!", :green)
      end
    end

    def latest_sequence_id
      Migration.migrations.keys.sort.last || 0
    end

    def current_sequence_id
      0
    end
  end
end

Dir[Dir.pwd + '/config/migrations/*.rb'].each do |migration_file|
  require(migration_file)
end
