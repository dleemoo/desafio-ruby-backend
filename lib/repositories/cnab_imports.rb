# frozen_string_literal: true

module Repositories
  class CnabImports < ROM::Repository[:cnab_imports]
    include Import[container: "rom"]
  end
end
