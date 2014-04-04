class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.belongs_to :item, index: true
      t.belongs_to :shop, index: true
      t.float :current_price
      t.float :price_diff

      t.timestamps
    end
  end
end
