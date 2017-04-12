class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :email_pc
      t.string :email_phone

      t.timestamps
    end
    add_index :contacts, :user_id, unique: true
  end
end
