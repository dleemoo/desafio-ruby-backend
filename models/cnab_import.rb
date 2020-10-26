# frozen_string_literal: true

module Models
  class CnabImport < Sequel::Model
    include Lib["uploaders.text_file"][:file]

    def self.listing
      order(Sequel.desc(:created_at))
    end
  end
end
