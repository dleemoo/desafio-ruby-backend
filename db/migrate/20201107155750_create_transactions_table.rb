# frozen-string-literal: true

ROM::SQL.migration do
  change do
    create_table(:transactions) do
      primary_key :id
      Time        :created_at, null: false
      Time        :updated_at, null: false
      foreign_key :store_id, :stores, null: false, index: true
      Decimal     :amount, null: false
      String      :type, null: false
      String      :identity_number, null: false
      String      :card_number, null: false
      Time        :timestamp, null: false
    end
  end
end
