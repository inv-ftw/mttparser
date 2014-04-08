class Shop < ActiveRecord::Base
  has_many :tags
  accepts_nested_attributes_for :tags, allow_destroy: true
end
