class AddPostToShop < ActiveRecord::Migration
  def change
    add_column :shops, :post, :boolean, null: false, default: false
  end
end
