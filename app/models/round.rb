class Round < ApplicationRecord
  belongs_to :competition
  has_many :groups, dependent: :destroy
  has_many :matches, through: :groups
  validates :name, presence: true, uniqueness: { scope: :competition }

  before_validation :set_points, on: :create
  after_commit :refresh_materialized_views

  private

  def set_points
    self.points ||= number + 2
  end
end
