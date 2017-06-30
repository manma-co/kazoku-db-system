class CreateProfileFamilies < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_families do |t|
      t.integer :job_style # 1 means both work, 0 means mother or father work, another does not.
      t.integer :number_of_children
      t.integer :is_photo_ok # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_report_ok # 1 means ok, 2 means ok if the face of child is not clear, 0 means bad.
      t.integer :is_male_ok # 1 means ok, 0 means NG
      t.string :has_time_shortening_experience
      t.string :has_childcare_leave_experience
      t.string :has_job_change_experience
      t.string :married_mother_age
      t.string :married_father_age
      t.string :first_childbirth_mother_age
      t.date :child_birthday
      t.string :opinion_or_question

      t.timestamps
    end
    add_reference :profile_families, :user
  end
end
