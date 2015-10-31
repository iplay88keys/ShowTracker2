class Episode < ActiveRecord::Base
  belongs_to :series
  has_many :users, through: :watches
  has_many :watches
end
