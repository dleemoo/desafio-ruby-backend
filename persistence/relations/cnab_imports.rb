# frozen_string_literal: true

module Persistence
  module Relations
    class CnabImports < ROM::Relation[:sql]
      schema(:cnab_imports, infer: true)
    end
  end
end
