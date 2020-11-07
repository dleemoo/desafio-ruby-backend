# frozen-string-literal: true

module Entities
  class CnabImport < Dry::Struct
    attribute :file_data, Types::Hash

    include Lib["uploaders.text_file"][:file]
  end
end
