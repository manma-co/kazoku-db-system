class CreateJobDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :job_domains do |t|
      t.string :domain
      t.timestamps
    end
    add_reference :job_domains, :profile_individual
  end
end
