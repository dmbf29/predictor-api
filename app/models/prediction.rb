class Prediction < ApplicationRecord
  belongs_to :match
  belongs_to :user
  validates :choice, presence: true
  enum choice: %i[home away draw]
end
