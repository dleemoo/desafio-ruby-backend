# frozen-string-literal: true

Sequel.migration do
  up do
    create_table(:transactions) do
      primary_key :id
      Time        :created_at, null: false
      Time        :updated_at, null: false
      foreign_key :store_id, :stores, null: false
      Decimal     :amount, null: false
      String      :type, null: false
      String      :identity_number, null: false
      String      :card_number, null: false
      Time        :timestamp, null: false

      index :store_id
    end
  end

  down { drop_table(:transactions) }
end
