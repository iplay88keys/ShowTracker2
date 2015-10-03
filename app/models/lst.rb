class Lst < ActiveRecord::Base
  belongs_to :user
  has_many :series
end
