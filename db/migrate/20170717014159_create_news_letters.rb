class CreateNewsLetters < ActiveRecord::Migration[5.0]
  def change
    create_table :news_letters do |t|
      t.string :subject
      t.text :content
      t.datetime :distribution
      t.string :send_to
      t.boolean :is_sent
      t.boolean :is_save
      t.boolean :is_monthly

      t.timestamps
    end
  end
end
