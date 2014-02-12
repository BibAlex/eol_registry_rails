class AddFileMd5HashToPullEvents < ActiveRecord::Migration
  def change
    add_column :pull_events, :file_md5_hash, :string
  end
end
