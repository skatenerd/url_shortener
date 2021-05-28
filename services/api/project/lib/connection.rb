class Connection
  DB = Sequel.connect(ENV['DB_URL'])
end
