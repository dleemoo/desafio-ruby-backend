# frozen_string_literal: true

module Cnab
  class EntryMapper
    include Import[
      "cnab.timestamp_mapper",
      "contracts.cnab_import_contract"
    ]

    def call(input) # rubocop:disable Metrics/MethodLength
      cnab_import_contract.call(
        type: type(input),
        amount: amount(input),
        identity_number: identity_number(input),
        card_number: card_number(input),
        timestamp: timestamp_mapper.call(input),
        store: {
          owner: store_owner(input),
          name: store_name(input)
        }
      ).to_monad
    end

    private

    def type(input)
      input[0..0]
    end

    def amount(input)
      BigDecimal(input[9..18].to_s) / 100
    rescue ArgumentError
      nil
    end

    def identity_number(input)
      input[19..29]
    end

    def card_number(input)
      input[30..41]
    end

    def store_owner(input)
      String(input[48..61]).strip
    end

    def store_name(input)
      String(input[62..80]).strip
    end
  end
end
