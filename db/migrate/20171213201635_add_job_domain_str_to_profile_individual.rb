class AddJobDomainStrToProfileIndividual < ActiveRecord::Migration[5.0]
  def change
    add_column :profile_individuals, :job_domain_str, :string
  end
end
