class CreatePushRequests < ActiveRecord::Migration
  def change
    create_table :push_requests do |t|
      t.integer :site_id
      t.string :file_url
      t.string :file_md5_hash
      t.datetime :received_at
      t.datetime :success_at
      t.datetime :failed_at
      t.string :failed_reason
      t.string :uuid
      t.integer :success

      t.timestamps
    end
  end
end
