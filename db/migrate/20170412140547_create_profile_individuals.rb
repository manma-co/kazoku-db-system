class CreateProfileIndividuals < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_individuals do |t|
      t.integer :profile_family_id, null: false
      t.datetime :birthday
      t.integer :job_domain
      t.string :role

      t.timestamps
    end
  end
end
