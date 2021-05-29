./wait-for-it.sh db:5432

ruby project/do_migrations.rb

ruby project/server.rb
