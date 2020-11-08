# frozen_string_literal: true

module Persistence
  module Commands
    class CreateCnabImport < ROM::SQL::Commands::Create
      relation :cnab_imports
      register_as :create_cnab_import

      def execute(tuples)
        super(tuples_with_timestamp(tuples))
      end

      private

      def tuples_with_timestamp(tuple)
        now = Time.now
        { created_at: now, updated_at: now }.merge(tuple)
      end
    end
  end
end
