class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :kana, null: false
      t.integer :sex, null: false # 0 is woman, 1 is man, maybe 2 is other status.
      t.boolean :is_family, null: false, default: true

      t.timestamps null: false
    end
  end
end
