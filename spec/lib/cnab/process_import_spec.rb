# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/cnab/process_import"

RSpec.describe Cnab::ProcessImport do
  let(:process) { described_class.new }

  let(:cnab_imports) { Lib["models.cnab_imports"] }
  let(:valid_file) { Pathname(__dir__).join("valid_example.txt") }
  let(:invalid_file) { Pathname(__dir__).join("invalid_example.txt") }

  describe "#call" do
    context "with invalid input" do
      it "returns failure and entities with error details" do
        cnab_import = cnab_imports.create(file: File.open(invalid_file))

        result = process.call(cnab_import.id)

        expect(result).to be_failure
        all_errors = result.failure.map { |item| item.failure.errors.to_h }
        expect(all_errors).to eq(
          [
            {
              amount: ["must be a decimal"],
              identity_number: ["must be a string"],
              card_number: ["must be a string"],
              timestamp: ["must be a time"],
              store: {
                owner: ["size cannot be less than 1"],
                name: ["size cannot be less than 1"]
              }
            },
            {
              type: ["must be greater than or equal to 1"],
              amount: ["must be a decimal"],
              identity_number: ["must be a string"],
              card_number: ["must be a string"],
              timestamp: ["must be a time"],
              store: {
                owner: ["size cannot be less than 1"],
                name: ["size cannot be less than 1"]
              }
            }
          ]
        )
      end
    end

    context "with a valid input" do
      it "creates the required object at the database" do
        cnab_import = cnab_imports.create(file: File.open(valid_file))

        result = process.call(cnab_import.id)
        expect(result).to be_success
      end

      it "returns a success object" do
        cnab_import = cnab_imports.create(file: File.open(valid_file))

        expect { process.call(cnab_import.id) }
          .to change(Lib["models.stores"], :count).by(2)
          .and change(Lib["models.transactions"], :count).by(3)
      end
    end
  end
end
