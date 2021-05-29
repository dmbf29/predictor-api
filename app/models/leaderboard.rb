class Leaderboard < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships, dependent: :destroy
  validates :name, presence: true
  has_secure_token :password

  def users
    User.includes(:memberships).where(memberships: { leaderboard: self }).or(User.where(id: users))
  end
end

