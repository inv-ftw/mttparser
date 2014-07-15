class Tag < ActiveRecord::Base
  belongs_to :shop
  scope :item, -> {where(destination: 'item').first}
  scope :price, -> {where(destination: 'price').first}
  scope :params, -> {where(destination: 'post-params').first}
end
