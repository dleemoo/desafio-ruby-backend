# frozen_string_literal: true

module Contracts
  class CnabImportContract < Dry::Validation::Contract
    params do
      required(:type).value(:integer) { gteq?(1) & lteq?(9) }
      required(:amount).value(:decimal)
      required(:identity_number).value(Types::String) { size?(11) }
      required(:card_number).value(Types::String) { size?(12) }

      required(:timestamp).value(Types::Time)

      required(:store).hash do
        required(:owner).value(:string) { min_size?(1) & max_size?(14) }
        required(:name).value(:string) { min_size?(1) & max_size?(19) }
      end
    end

    rule(:amount) { values[:amount] = -value if DEBIT_TRANSACTIONS.include?(values[:type]) }
    rule(:type) { values[:type] = TRANSACTION_TYPES[value] }

    TRANSACTION_TYPES = {
      1 => "Débito",
      2 => "Boleto",
      3 => "Financiamento",
      4 => "Crédito",
      5 => "Recebimento Empréstimo",
      6 => "Vendas",
      7 => "Recebimento TED",
      8 => "Recebimento DOC",
      9 => "Aluguel"
    }.freeze

    DEBIT_TRANSACTIONS = [2, 3, 9].freeze

    private_constant :TRANSACTION_TYPES, :DEBIT_TRANSACTIONS
  end
end
