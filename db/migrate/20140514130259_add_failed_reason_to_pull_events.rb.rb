class AddFailedReasonToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :failed_reason, :string, :default => nil
  end
end
