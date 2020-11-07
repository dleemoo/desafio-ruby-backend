# frozen_string_literal: true

module Cnab
  class ProcessImport
    include Import[
      "cnab.entry_mapper",
      "repositories.cnab_imports",
      "repositories.stores",
      "repositories.transactions"
    ]

    def call(cnab_import_id)
      entries = read_entries_from(cnab_import_id)

      return Dry::Monads::Failure(entries) if entries.any?(&:failure?)

      Dry::Monads::Success(create_transactions(entries))
    end

    def create_transactions(entries)
      stores.transaction do
        entries.map do |entry|
          attrs = entry.value!.to_h
          store = create_or_find_store(attrs[:store])
          transactions.root.changeset(
            :create, attrs.reject { |key, _| key == :store }.merge(store_id: store.id)
          ).map(:add_timestamps).commit
        end
      end
    end

    def create_or_find_store(name:, owner:)
      stores.root.where(name: name, owner: owner).one ||
        stores.root.changeset(:create, name: name, owner: owner).map(:add_timestamps).commit
    end

    def read_entries_from(cnab_import_id)
      file_contents(cnab_import_id).map { |line| entry_mapper.call(line) }
    end

    def file_contents(cnab_import_id)
      (Lib["entities.cnab_import"] rescue nil)

      cnab_import = cnab_imports.root.by_pk(cnab_import_id).one
      entity = Entities::CnabImport.new(file_data: cnab_import.file_data)

      entity.file.read.split("\n")
    end
  end
end
