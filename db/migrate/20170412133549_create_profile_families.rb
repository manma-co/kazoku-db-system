class CreateProfileFamilies < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_families do |t|
      t.integer :job_style # 1 means both work, 0 means mother or father work, another does not.
      t.integer :number_of_children
      t.integer :is_photo_ok  # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_report_ok  # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_male_ok # 1 means ok, 0 means NG
      t.date :child_birthday

      t.timestamps
    end
    add_reference :profile_families, :user
  end
end
