class Result < ActiveRecord::Base
  require 'open-uri'
  belongs_to :item
  belongs_to :shop

end
