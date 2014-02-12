class AddSuccessToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :success, :integer, :default => nil
  end
end
