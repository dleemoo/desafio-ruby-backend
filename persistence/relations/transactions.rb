# frozen_string_literal: true

module Persistence
  module Relations
    class Transactions < ROM::Relation[:sql]
      schema(:transactions, infer: true) do
        associations do
          belongs_to :store
        end
      end
    end
  end
end
