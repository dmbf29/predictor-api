class Round < ApplicationRecord
  belongs_to :competition
  has_many :groups, dependent: :destroy
  has_many :matches, through: :groups
  validates :name, presence: true

  def points
    number + 2
  end
end
