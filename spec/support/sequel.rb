# frozen_string_literal: true

DB.create_table :sequel_dummy_models do
  primary_key :id
  String :state
end
