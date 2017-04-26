class CreateProfileFamilies < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_families do |t|
      t.integer :user_id, null: false
      t.integer :job_style # 1 means both work, 0 means mother or father work, another does not.
      t.integer :number_of_children
      t.integer :is_photo_ok  # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_sns_ok  # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_male_ok # 1 means ok, 2 means NG

      t.timestamps
    end
    add_index :profile_families, :user_id, unique: true
  end
end
