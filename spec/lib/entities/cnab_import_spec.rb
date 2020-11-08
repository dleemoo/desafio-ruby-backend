# frozen_string_literal: true

require "spec_helper"

RSpec.describe Entities::CnabImport do
  let(:entity_builder) { described_class }

  include Import[uploader: "uploaders.text_file"]

  let(:now) { Time.now }
  let(:tempfile) { StringIO.new(" line1\nline2  \nline3\n") }
  let(:upload) { uploader.upload(tempfile, :store) }
  let(:file_data) { upload.data }
  let(:valid_params) { { id: 1, created_at: now, updated_at: now, file_data: file_data } }

  describe "#new" do
    context "with invalid input" do
      it "returns a valid entity" do
        entity = entity_builder.new(valid_params)

        expect(entity).to be_a_instance_of(described_class)
        expect(entity.id).to eq(1)
        expect(entity.created_at).to eq(now)
        expect(entity.updated_at).to eq(now)
        expect(entity.file_data).to eq(file_data)
        expect(entity.entries).to eq([" line1", "line2  ", "line3"])
      end
    end

    context "when some parameter is missing" do
      it "rejects to build entity" do
        valid_params.each_key do |exclude_key|
          params = valid_params.reject { |key| key == exclude_key }
          expect { entity_builder.new(params) }
            .to raise_error(Dry::Struct::Error, /#{exclude_key} is missing/)
        end
      end

      it "rejects non integer ids" do
        params = valid_params.merge(id: "39")
        expect { entity_builder.new(params) }
          .to raise_error(
            Dry::Struct::Error,
            /"39" \(String\) has invalid type for :id violates constraints \(type\?\(Integer, "39"\) failed\)/
          )
      end

      it "rejects non time for created_at" do
        params = valid_params.merge(created_at: 30)
        expect { entity_builder.new(params) }
          .to raise_error(
            Dry::Struct::Error,
            /30 \(Integer\) has invalid type for :created_at violates constraints \(type\?\(Time, 30\) failed\)/
          )
      end

      it "rejects non time for updated_at" do
        params = valid_params.merge(updated_at: [])
        expect { entity_builder.new(params) }
          .to raise_error(
            Dry::Struct::Error,
            /\[\] \(Array\) has invalid type for :updated_at violates constraints \(type\?\(Time, \[\]\) failed\)/
          )
      end

      it "rejects non Hash input for file_data" do
        params = valid_params.merge(file_data: "error")
        expect { entity_builder.new(params) }
          .to raise_error(
            Dry::Struct::Error,
            /"error" \(String\) has invalid type for :file_data violates constraints \(type\?\(Hash, "error"\) failed\)/
          )
      end
    end
  end
end
