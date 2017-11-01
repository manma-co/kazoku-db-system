class AddColumnAmazonGiftToEventDate < ActiveRecord::Migration[5.0]
  def change
    add_column :event_dates, :is_amazon_card, :boolean
  end
end
