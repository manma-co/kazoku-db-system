class CreateNewsLetters < ActiveRecord::Migration[5.0]
  def change
    create_table :news_letters do |t|
      t.string :subject
      t.text :content
      t.datetime :distribution
      t.string :send_to
      t.boolean :is_sent, default: false
      t.boolean :is_save, default: false
      t.boolean :is_monthly, default: false

      t.timestamps
    end
  end
end
