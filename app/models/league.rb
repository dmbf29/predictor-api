class League < ApplicationRecord
  belongs_to :user
  belongs_to :competition
end
