# frozen-string-literal: true

Sequel.migration do
  up do
    create_table(:cnab_imports) do
      primary_key :id
      Time   :created_at, null: false
      Time   :updated_at, null: false
      String :file_data,  null: false, text: true # change:jsonb
    end
  end

  down { drop_table(:cnab_imports) }
end
