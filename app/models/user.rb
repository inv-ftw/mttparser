#encoding: utf-8
class User < ActiveRecord::Base
  has_secure_password
end
