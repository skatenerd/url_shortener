require 'sequel'
Sequel.extension :migration
DB = Sequel.connect(ENV['DB_URL'])
Sequel::Migrator.run(DB, "project/db/migrations")
