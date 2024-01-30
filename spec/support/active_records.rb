# frozen_string_literal: true

ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Migration.create_table 'dummy_models', force: true do |t|
    t.string 'state'
  end

  ActiveRecord::Migration.create_table 'another_dummy_models', force: true do |t|
    t.string 'state'
  end
end
