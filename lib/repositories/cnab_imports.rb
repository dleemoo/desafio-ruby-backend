# frozen_string_literal: true

module Repositories
  class CnabImports < ROM::Repository[:cnab_imports]
    include Import[container: "rom"]

    struct_namespace Entities
    auto_struct true

    def create(input)
      cnab_imports.command(:create_cnab_import, result: :one).call(input).first
    end
  end
end
