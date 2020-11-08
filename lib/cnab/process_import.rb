# frozen_string_literal: true

module Cnab
  class ProcessImport
    include Dry::Monads[:result]
    include Import[
      "repositories.transactions",
      process_entry: "cnab.entry_mapper"
    ]

    def call(cnab_import)
      entries = cnab_import.entries.map { |entry| process_entry.call(entry) }

      return Failure(entries) if entries.any?(&:failure?)

      Success(
        transactions.create_with_store(
          entries.map { |entry| entry.value!.to_h }
        )
      )
    end
  end
end
