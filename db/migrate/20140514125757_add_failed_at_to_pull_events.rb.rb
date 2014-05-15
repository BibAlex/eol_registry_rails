class AddFailedAtToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :failed_at, :datetime, :default => nil
  end
end
