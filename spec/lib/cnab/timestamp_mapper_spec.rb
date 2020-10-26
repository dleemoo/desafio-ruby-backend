# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/cnab/timestamp_mapper"

RSpec.describe Cnab::TimestampMapper do
  let(:mapper) { described_class.new }

  describe "#call" do
    context "with invalid input" do
      it "returns nil for nil" do
        expect(mapper.call(nil)).to eq(nil)
      end

      it "returns nil for empty string" do
        expect(mapper.call("")).to eq(nil)
      end

      it "returns nil for blank string" do
        input = "                                                "
        expect(mapper.call(input)).to eq(nil)
      end

      it "returns nil for invalid date value" do
        input = " 20201032                                 123456"
        expect(mapper.call(input)).to eq(nil)
      end

      it "returns nil for non numeric date value" do
        input = " @@@@@@@@                                 123456"
        expect(mapper.call(input)).to eq(nil)
      end

      it "returns nil for non complete date value" do
        input = " 202 1026                                 123400"
        expect(mapper.call(input)).to eq(nil)
      end

      it "returns nil for non numeric time value" do
        input = " 20201026                                 @@@@@@"
        expect(mapper.call(input)).to eq(nil)
      end

      it "returns nil for non complete time value" do
        input = " 20201026                                 12 400"
        expect(mapper.call(input)).to eq(nil)
      end
    end

    context "with a valid input" do
      it "returns the timestamp from 1..8 and 42..47 positions" do
        input = " 20201026                                 123456"
        expect(mapper.call(input)).to eq(Time.new(2020, 10, 26, 12, 34, 56, "+03:00"))
      end
    end
  end
end
