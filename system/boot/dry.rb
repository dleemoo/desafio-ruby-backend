# frozen_string_literal: true

Lib.boot(:dry) do
  init do
    require "dry-validation"
    require "dry-monads"
  end

  start do
    Dry::Validation.load_extensions(:monads)
  end
end
