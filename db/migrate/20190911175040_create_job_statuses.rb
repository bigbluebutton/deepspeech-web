# rubocop:disable Style/Documentation
# frozen_string_literal: true

class CreateJobStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :job_statuses do |t|
      t.string :job_id
      t.string :status

      t.timestamps
    end
  end
end
# rubocop:enable Style/Documentation
