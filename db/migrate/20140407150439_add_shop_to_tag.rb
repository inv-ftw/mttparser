class AddShopToTag < ActiveRecord::Migration
  def change
    add_reference :tags, :shop, index: true
  end
end
