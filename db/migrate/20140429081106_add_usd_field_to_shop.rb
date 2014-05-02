class AddUsdFieldToShop < ActiveRecord::Migration
  def change
    add_column :shops, :usd, :boolean
  end
end
