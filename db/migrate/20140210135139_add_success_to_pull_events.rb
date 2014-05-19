class AddSuccessToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :success, :boolean, :default => nil
  end
end
