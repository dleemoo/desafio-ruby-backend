# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cnab::Upload do
  let(:uploader) { described_class.new }

  let(:cnab_relation) { Lib[:rom].relations[:cnab_imports] }

  describe "#call" do
    it "raise error for invalid input" do
      expect { uploader.call("some-file") }.to raise_error(JSON::ParserError)
    end

    it "creates a new cnab_imports record" do
      expect do
        uploader.call(
          filename: "a.txt",
          type: "text/plain",
          name: "file",
          tempfile: StringIO.new("some-text-file-content")
        )
      end.to change(cnab_relation, :count).by(1)
    end
  end
end
