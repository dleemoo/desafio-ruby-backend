# frozen_string_literal: true

module Models
  class Store < Sequel::Model
    one_to_many :transactions

    def self.listing
      order(Sequel.desc(:name))
    end

    def self.amount_by_store
      association_join(:transactions)
        .group(:store_id)
        .select { [store_id, sum(transactions[amount]).as(total)] }
        .to_hash(:store_id, :total)
    end
  end
end
