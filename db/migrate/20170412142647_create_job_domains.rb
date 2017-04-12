class CreateJobDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :job_domains do |t|
      t.string :domain

      t.timestamps
    end
  end
end
