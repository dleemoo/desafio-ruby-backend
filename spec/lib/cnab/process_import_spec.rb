# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cnab::ProcessImport do
  subject(:process) { described_class.new }

  include Import[uploader: "uploaders.text_file"]

  let(:upload) { uploader.upload(file, :store) }
  let(:cnab_import) { Factory[:cnab_import, file_data: upload.data] }
  let(:store_relation) { Lib[:rom].relations[:stores] }
  let(:transaction_relation) { Lib[:rom].relations[:transactions] }

  describe "#call" do
    context "with invalid input" do
      let(:file) { File.open(Pathname(__dir__).join("invalid_example.txt")) }

      it "returns failure and entities with error details" do
        result = process.call(cnab_import)

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
        result = process.call(cnab_import)
        expect(result).to be_success
      end

      it "creates the records at the database" do
        expect { process.call(cnab_import) }
          .to change(store_relation, :count).by(2)
          .and change(transaction_relation, :count).by(3)
      end
    end
  end
end
