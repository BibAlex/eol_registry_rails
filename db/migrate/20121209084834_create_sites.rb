class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :current_uuid
      t.string :url
      t.string :auth_code
      t.string :response_url

      t.timestamps
    end
  end
end
