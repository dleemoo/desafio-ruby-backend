# frozen_string_literal: true

require "dry/system/components"

Lib.boot(:settings, from: :system) do
  settings do
    key :rack_env, Types::String
    key :database_url, Types::String
    key :test_database_url, Types::String.default("")
  end
end
