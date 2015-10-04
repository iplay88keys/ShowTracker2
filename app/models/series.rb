class Series < ActiveRecord::Base
  has_many :episodes
  has_many :lst
end
