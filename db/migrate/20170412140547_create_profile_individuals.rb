class CreateProfileIndividuals < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_individuals do |t|
      t.datetime :birthday
      t.string :hometown
      t.string :role
      t.string :company
      t.string :career
      t.string :has_experience_abroad

      t.timestamps
    end
    add_reference :profile_individuals, :profile_family
  end
end
