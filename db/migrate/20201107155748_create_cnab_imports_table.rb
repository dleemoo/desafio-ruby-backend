# frozen-string-literal: true

ROM::SQL.migration do
  change do
    create_table(:cnab_imports) do
      primary_key :id
      Time   :created_at, null: false
      Time   :updated_at, null: false
      jsonb  :file_data,  null: false
    end
  end
end
