class CreatePullEvents < ActiveRecord::Migration
  def change
    create_table :pull_events do |t|
      t.integer :site_id
      t.datetime :pull_at
      t.datetime :success_at
      t.string :state_uuid

      t.timestamps
    end
  end
end
