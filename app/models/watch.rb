class Watch < ActiveRecord::Base
  belongs_to :episode
  belongs_to :user
  belongs_to :series
end
