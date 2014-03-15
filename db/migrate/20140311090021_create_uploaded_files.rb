class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :type
      t.string :user_session_id
      t.attachment :uploaded

      t.timestamps
    end
  end
end
