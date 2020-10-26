# frozen_string_literal: true

Lib.boot(:shrine) do
  init do
    require "shrine"
    require "shrine/storage/file_system"
  end

  start do
    Shrine.storages = {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
    }

    Shrine.plugin :sequel
    Shrine.plugin :cached_attachment_data
    Shrine.plugin :restore_cached_data
    Shrine.plugin :rack_file
    Shrine.plugin :determine_mime_type

    register "uploaders.text_file", Class.new(Shrine)::Attachment
  end
end
