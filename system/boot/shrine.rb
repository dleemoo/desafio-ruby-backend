# frozen_string_literal: true

Lib.boot(:shrine) do
  init do
    require "shrine"
    require "shrine/storage/file_system"
  end

  start do
    if Lib.env == "test"
      require "shrine/storage/memory"
      Shrine.storages = {
        cache: Shrine::Storage::Memory.new,
        store: Shrine::Storage::Memory.new
      }
    else
      Shrine.storages = {
        cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
        store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
      }
    end

    Shrine.plugin :rom
    Shrine.plugin :rack_file
    Shrine.plugin :determine_mime_type
    Shrine.plugin :validation_helpers

    class TextFileUploader < Shrine
      Attacher.validate do
        validate_extension %w[txt text]
        validate_mime_type %w[text/plain]
      end
    end

    register "uploaders.text_file", TextFileUploader
    register "uploaders.text_file_attacher", TextFileUploader::Attacher
  end
end
