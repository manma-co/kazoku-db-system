class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :tel
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :kana_first
      t.string :kana_last
      t.boolean :sex, null: false # 0 is woman, 1 is man
      t.string :zip_code1
      t.string :zip_code2
      t.string :prefecture
      t.string :address1
      t.string :address2
      t.boolean :is_family, null: false, default: true

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
