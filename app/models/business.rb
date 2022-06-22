class Business < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  has_many :users, through: :reviews
end
