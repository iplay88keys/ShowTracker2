class Series < ActiveRecord::Base
  has_many :episodes
  belongs_to :lst
end
