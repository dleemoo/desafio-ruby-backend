# frozen_string_literal: true

module Cnab
  class Upload
    include Import["models.cnab_imports"]

    def call(http_file_upload)
      cnab_imports.create(file: http_file_upload)
    end
  end
end
