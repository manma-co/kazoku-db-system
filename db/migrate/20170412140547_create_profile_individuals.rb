class CreateProfileIndividuals < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_individuals do |t|
      t.datetime :birthday
      t.string :role

      t.timestamps
    end
    add_reference :profile_individuals, :profile_family
  end
end
