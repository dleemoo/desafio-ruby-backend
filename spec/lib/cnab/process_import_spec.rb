# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cnab::ProcessImport do
  subject(:process) { described_class.new }

  include Import[
    "uploaders.text_file",
    "repositories.cnab_imports",
    "repositories.stores",
    "repositories.transactions"
  ]

  describe "#call" do
    context "with invalid input" do
      let(:file) { File.open(Pathname(__dir__).join("invalid_example.txt")) }

      it "returns failure and entities with error details" do
        upload = text_file.upload(file, :store)

        cnab_import = cnab_imports
          .root
          .changeset(:create, file_data: upload.data)
          .map(:add_timestamps)
          .commit

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
      let(:file) { File.open(Pathname(__dir__).join("valid_example.txt")) }

      it "returns a success object" do
        upload = text_file.upload(file, :store)

        cnab_import = cnab_imports
          .root
          .changeset(:create, file_data: upload.data)
          .map(:add_timestamps)
          .commit

        result = process.call(cnab_import.id)
        expect(result).to be_success
      end

      it "creates the records at the database" do
        upload = text_file.upload(file, :store)

        cnab_import = cnab_imports
          .root
          .changeset(:create, file_data: upload.data)
          .map(:add_timestamps)
          .commit

        expect { process.call(cnab_import.id) }
          .to change(stores.root, :count).by(2)
          .and change(transactions.root, :count).by(3)
      end
    end
  end
end
