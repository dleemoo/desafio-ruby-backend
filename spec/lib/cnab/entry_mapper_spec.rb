# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cnab::EntryMapper do
  let(:mapper) { described_class.new }

  describe "#call" do
    context "with invalid input" do
      it "returns failire with error details" do
        input = ""
        result = mapper.call(input)

        expect(result).to be_failure
        expect(result.failure.errors.to_h).to eq(
          type: ["must be an integer"],
          amount: ["must be a decimal"],
          card_number: ["must be a string"],
          identity_number: ["must be a string"],
          timestamp: ["must be a time"],
          store: {
            owner: ["size cannot be less than 1"],
            name: ["size cannot be less than 1"]
          }
        )
      end

      it "returns failire with error details for some arguments" do
        input = "320200201                                 123456                               "
        result = mapper.call(input)

        expect(result).to be_failure
        expect(result.failure.errors.to_h).to eq(
          amount: ["must be a decimal"],
          store: {
            owner: ["size cannot be less than 1"],
            name: ["size cannot be less than 1"]
          }
        )
      end
    end

    context "transaction type mapping" do
      let(:types) do
        {
          1 => "Débito",
          2 => "Boleto",
          3 => "Financiamento",
          4 => "Crédito",
          5 => "Recebimento Empréstimo",
          6 => "Vendas",
          7 => "Recebimento TED",
          8 => "Recebimento DOC",
          9 => "Aluguel"
        }
      end

      it "returns the valid name for each operation" do
        (1..9).each do |type|
          mapped_type = mapper.call("#{type}...").failure.to_h[:type]
          expect(mapped_type).to eq(types[type])
        end
      end
    end

    context "amount mapping" do
      let(:negative_value_operations) { [2, 3, 9] }
      let(:positive_value_operations) { [1, 4, 5, 6, 7, 8] }

      it "returns a negative value for outflow operation" do
        negative_value_operations.each do |type|
          input = "#{type}201903010000015234...."
          data = mapper.call(input).failure.to_h

          expect(data[:amount]).to eq(-BigDecimal("152.34"))
        end
      end

      it "returns a positive value for inflow operation" do
        positive_value_operations.each do |type|
          input = "#{type}201903010000015234...."
          data = mapper.call(input).failure.to_h

          expect(data[:amount]).to eq(BigDecimal("152.34"))
        end
      end
    end

    context "with a valid input" do
      it "returns success with the complete data" do
        input = "1201903010000015234096206760171234****7890233000JOÃO MACEDO   BAR DO JOÃO      "
        result = mapper.call(input)

        expect(result).to be_success
        expect(result.value!.to_h).to eq(
          type: "Débito",
          amount: BigDecimal("152.34"),
          identity_number: "09620676017",
          card_number: "1234****7890",
          timestamp: Time.new(2019, 3, 1, 23, 30, 0, "+03:00"),
          store: {
            owner: "JOÃO MACEDO",
            name: "BAR DO JOÃO"
          }
        )
      end
    end
  end
end
