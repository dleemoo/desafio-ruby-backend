# frozen_string_literal: true

require "dry/system/container"

require_relative "types"

class Lib < Dry::System::Container
  use :env, inferrer: -> { Types::String[ENV.fetch("ENV", "development")] }

  configure do |config|
    config.root = Pathname("#{__dir__}/..").expand_path
    config.auto_register = "lib"
  end
  load_paths!("lib")
end

Import = Lib
  .start(:settings)
  .start(:dry)
  .start(:debug)
  .start(:shrine)
  .start(:rom)
  .injector

Lib.finalize!
