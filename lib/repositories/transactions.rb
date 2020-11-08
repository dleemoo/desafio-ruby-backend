# frozen_string_literal: true

module Repositories
  class Transactions < ROM::Repository[:transactions]
    include Import[container: "rom"]

    def create_with_store(input)
      transactions.command(:create_with_store, result: :many).call(input)
    end
  end
end
