# frozen-string-literal: true

module Entities
  class CnabImport < ROM::Struct
    include Lib["uploaders.text_file"][:file]

    attribute :id, Types::Integer
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
    attribute :file_data, Types::Hash

    def entries
      @entries ||= file.read.split("\n")
    end
  end
end
