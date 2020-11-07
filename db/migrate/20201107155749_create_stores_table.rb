# frozen-string-literal: true

ROM::SQL.migration do
  change do
    create_table(:stores) do
      primary_key :id
      Time   :created_at, null: false
      Time   :updated_at, null: false
      String :name, null: false
      String :owner, null: false

      unique %i[name owner]
    end
  end
end
