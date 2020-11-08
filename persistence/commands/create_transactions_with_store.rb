# frozen_string_literal: true

module Persistence
  module Commands
    class CreateTransactionsWithStore < ROM::SQL::Commands::Create
      relation :transactions
      register_as :create_with_store

      def execute(tuples)
        relation.transaction do
          tuples.map do |tuple|
            store_tuple = tuple.delete(:store)
            transaction_tuple = tuple.merge(store_id: create_or_fetch_store(store_tuple)[:id])

            relation.changeset(:create, transaction_tuple).map(:add_timestamps).commit
          end
        end
      end

      private

      def create_or_fetch_store(tuple)
        relation.stores.where(tuple).one ||
          relation.stores.changeset(:create, tuple).map(:add_timestamps).commit
      end
    end
  end
end
