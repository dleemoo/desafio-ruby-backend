# frozen_string_literal: true

Factory.define(:cnab_import, struct_namespace: Entities) do |f|
  f.created_at { Time.now }
  f.updated_at { Time.now }
end
