class AddSkuToItem < ActiveRecord::Migration
  def change
    add_column :items, :sku, :string
  end
end
