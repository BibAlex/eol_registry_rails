class CreateSyncObjectTypes < ActiveRecord::Migration
  def change
    create_table :sync_object_types do |t|
      t.string :object_type

      t.timestamps
    end
  end
end
