# frozen_string_literal: true

module Models
  class Transaction < Sequel::Model
    many_to_one :store

    def self.listing
      order(Sequel.desc(:timestamp))
    end
  end
end
