class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :competition
end