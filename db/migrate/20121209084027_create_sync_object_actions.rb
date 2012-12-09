class CreateSyncObjectActions < ActiveRecord::Migration
  def change
    create_table :sync_object_actions do |t|
      t.string :object_action

      t.timestamps
    end
  end
end
