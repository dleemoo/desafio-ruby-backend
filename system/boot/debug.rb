# frozen_string_literal: true

Lib.boot(:debug) do
  init do
    require "pry" if Lib.env != "production"
  end
end
