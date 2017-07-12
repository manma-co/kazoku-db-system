class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :kana
      t.string :belong
      t.string :email

      t.timestamps
    end

    add_index :participants, :email, unique: true
  end
end
