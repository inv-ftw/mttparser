class AddBrandToItem < ActiveRecord::Migration
  def change
    add_column :items, :brand, :string
  end
end
