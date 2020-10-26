# frozen-string-literal: true

Sequel.migration do
  up do
    create_table(:stores) do
      primary_key :id
      Time   :created_at, null: false
      Time   :updated_at, null: false
      String :name, null: false
      String :owner, null: false

      unique %i[name owner]
    end
  end

  down { drop_table(:stores) }
end
