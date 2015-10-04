class Lst < ActiveRecord::Base
  belongs_to :user
  belongs_to :series
end
