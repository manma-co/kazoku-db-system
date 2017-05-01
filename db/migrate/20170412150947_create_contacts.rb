class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :email_pc
      t.string :email_phone

      t.timestamps
    end
    add_reference :contacts, :user
  end
end
