# frozen_string_literal: true

module Apps
  class Report < Roda
    plugin :render, escape: true

    include Import["models.stores"]

    route do |r|
      r.get "transactions-by-store" do
        @amount_by_store = stores.amount_by_store
        @stores = stores.listing
        view "reports/transactions_by_store"
      end
    end
  end
end
