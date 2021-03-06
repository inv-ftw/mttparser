class Shop < ActiveRecord::Base
  has_many :tags, dependent: :destroy
  accepts_nested_attributes_for :tags, allow_destroy: true
  validates :name, uniqueness: true

end
