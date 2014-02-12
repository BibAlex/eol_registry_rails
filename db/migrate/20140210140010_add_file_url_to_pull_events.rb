class AddFileUrlToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :file_url, :string
  end
end
