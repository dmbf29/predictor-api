class Round < ApplicationRecord
  belongs_to :competition
  has_many :groups
  has_many :matches, through: :groups
end
