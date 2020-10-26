# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/cnab/upload"

RSpec.describe Cnab::Upload do
  let(:uploader) { described_class.new }

  describe "#call" do
    it "raise error for invalid input" do
      expect { uploader.call("some-file") }.to raise_error(JSON::ParserError)
    end

    it "creates a new cnab_imports record" do
      tempfile = Tempfile.create

      expect do
        uploader.call(
          filename: "a.txt",
          type: "text/plain",
          name: "file",
          tempfile: tempfile
        )
      end.to change(Lib["models.cnab_imports"], :count).by(1)
    ensure
      FileUtils.rm(tempfile) if File.exist?(tempfile.path)
    end
  end
end
