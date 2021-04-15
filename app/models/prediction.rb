class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user
  validates_uniqueness_of :user, scope: :match
  validates :choice, presence: true
  enum choice: %i[home away draw]

  def correct?
    choice == match.winner_side
  end
end
