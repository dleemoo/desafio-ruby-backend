# frozen_string_literal: true

Lib.boot(:debug) do |container|
  init do
    require "pry" if container[:settings].rack_env != "production"
  end
end
