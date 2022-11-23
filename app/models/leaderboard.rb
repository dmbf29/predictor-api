class Leaderboard < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :locked_predictions, -> { locked }, through: :users, source: :predictions
  validates :name, presence: true
  has_secure_token :password
  after_create :create_owner_membership

  def transfer_ownership
    membership = memberships.first
    membership.destroy
    self.user = membership.user
    save
  end

  private

  def create_owner_membership
    memberships.create(user: user)
  end
end
