# frozen_string_literal: true

Factory.define(:store) do |f|
  f.created_at { Time.now }
  f.updated_at { Time.now }
  f.sequence(:name) { |n| "Store #{n}" }
  f.sequence(:owner) { |n| "Owner #{n}" }
end
