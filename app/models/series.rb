class Series < ActiveRecord::Base
  has_many :episodes
  has_many :lst
  has_many :users, through: :watches
  has_many :episodes, through: :watches
  has_many :watches
end
