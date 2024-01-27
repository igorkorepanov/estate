# frozen_string_literal: true

DB.create_table :dummy_models do
  primary_key :id
  String :state
end
