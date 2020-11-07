# frozen_string_literal: true

require "dry/system/components"

Lib.boot(:settings, from: :system) do
  settings do
    key :database_url, Types::String
    key :test_database_url, Types::String.default("")

    key :boot_rom, Types::Params::Bool.default(true)
  end
end
