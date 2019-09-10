# frozen_string_literal: true

# rubocop:disable Style/Documentation
class CreateJobstatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :jobstatuses do |t|
      t.string :jobID
      t.string :status
      t.timestamps
    end
  end
end
# rubocop:enable Style/Documentation
