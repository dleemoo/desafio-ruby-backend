# frozen_string_literal: true

module Repositories
  class Transactions < ROM::Repository[:transactions]
    include Import[container: "rom"]
  end
end
