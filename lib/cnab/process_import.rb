# frozen_string_literal: true

module Cnab
  class ProcessImport
    include Import[
      :db,
      "cnab.entry_mapper",
      "models.cnab_imports",
      "models.stores",
      "models.transactions"
    ]

    def call(cnab_import_id)
      entries = read_entries_from(cnab_import_id)

      return Dry::Monads::Failure(entries) if entries.any?(&:failure?)

      Dry::Monads::Success(create_transactions(entries))
    end

    def create_transactions(entries)
      db.transaction do
        entries.map do |entry|
          attrs = entry.value!.to_h
          store = create_or_find_store(attrs[:store])
          transactions.create(
            attrs.reject { |key, _| key == :store }.merge(store_id: store.id)
          )
        end
      end
    end

    def create_or_find_store(name:, owner:)
      stores.find(name: name, owner: owner) || stores.create(name: name, owner: owner)
    end

    def read_entries_from(cnab_import_id)
      file_contents(cnab_import_id).map { |line| entry_mapper.call(line) }
    end

    def file_contents(cnab_import_id)
      cnab_imports[cnab_import_id].file.read.split("\n")
    end
  end
end
