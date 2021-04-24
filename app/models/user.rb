class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable # :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :memberships, dependent: :destroy
  # TODO: Fix this
  # has_many :competitions, through: :leaderboards
  has_many :predictions, dependent: :destroy
  has_many :matches, through: :predictions

  def leaderboards
    # this includes creator or leaderboard and members
    Leaderboard.includes(:memberships).where(memberships: { user: self }).or(Leaderboard.where(user: self))
  end
end
