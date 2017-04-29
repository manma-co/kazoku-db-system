class CreateProfileIndividuals < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_individuals do |t|
      t.integer :profile_family_id, null: false
      t.datetime :birthday
      t.integer :job_domain_id
      t.string :role

      t.timestamps
    end
    add_index :profile_individuals, :job_domain_id, unique: true
  end
end
