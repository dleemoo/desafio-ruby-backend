# frozen_string_literal: true

module Repositories
  class Stores < ROM::Repository[:stores]
    include Import[container: "rom"]

    def listing
      stores.combine(:transactions).order(stores[:name]).to_a
    end

    def amount_by_store
      stores
        .join(:transactions)
        .dataset
        .group { stores[:id] }
        .select { [stores[:id], sum(transactions[:amount]).as(:total)] }
        .as_hash(:id, :total)
    end
  end
end
