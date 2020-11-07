# frozen_string_literal: true

module Persistence
  module Relations
    class Stores < ROM::Relation[:sql]
      schema(:stores, infer: true) do
        associations do
          has_many :transactions
        end
      end
    end
  end
end
