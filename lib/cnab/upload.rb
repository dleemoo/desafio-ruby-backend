# frozen_string_literal: true

module Cnab
  class Upload
    include Import[
      "repositories.cnab_imports",
      "uploaders.text_file_attacher"
    ]

    def call(http_file_upload)
      attacher = text_file_attacher.new.tap { |f| f.assign(http_file_upload) }

      return Dry::Monads::Failure(attacher.errors) unless attacher.validate

      Dry::Monads::Success(
        cnab_imports
        .root
        .changeset(:create, file_data: attacher.data)
        .map(:add_timestamps)
        .commit
      )
    end
  end
end
