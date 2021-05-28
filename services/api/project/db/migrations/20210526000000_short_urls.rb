Sequel.migration do
  change do
    create_table(:short_urls) do
      primary_key :id
      String :destination, null: false, unique: true
      String :slug, null: false, unique: true
    end
  end
end
