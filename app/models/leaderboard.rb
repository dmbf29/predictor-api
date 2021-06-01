class Leaderboard < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  validates :name, presence: true
  has_secure_token :password

  def users
    super().or(User.where(id: user))
  end
end
