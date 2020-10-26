# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/contracts/cnab_import_contract"

RSpec.describe Contracts::CnabImportContract do
  let(:contract) { described_class.new }

  describe "#call" do
    context "with invalid input" do
      it "returns failire with error details" do
        result = contract.call({})

        expect(result).to be_failure
        expect(result.errors.to_h).to eq(
          type: ["is missing"],
          amount: ["is missing"],
          card_number: ["is missing"],
          identity_number: ["is missing"],
          timestamp: ["is missing"],
          store: ["is missing"]
        )
      end
    end

    context "with a valid input" do
      it "returns success with the complete data" do
        now = Time.now
        result = contract.call(
          type: 1,
          amount: 155.32,
          identity_number: "09620676017",
          card_number: "1234****7890",
          timestamp: now,
          store: {
            name: "store-name",
            owner: "owner-name"
          }
        )

        expect(result).to be_success
        expect(result.to_h).to eq(
          type: "Débito",
          amount: BigDecimal("155.32"),
          identity_number: "09620676017",
          card_number: "1234****7890",
          timestamp: now,
          store: {
            name: "store-name",
            owner: "owner-name"
          }
        )
      end
    end
  end
end
