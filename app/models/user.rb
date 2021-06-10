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

  def leaderboards(competition = nil)
    # this includes creator or leaderboard and members
    leaderboards = Leaderboard.includes(:memberships).where(memberships: { user: self }).or(Leaderboard.where(user: self))
    leaderboards = leaderboards.where(competition: competition) if competition
    leaderboards
  end

  def display_name
    name || email
  end

  def score(competition)
    # TODO: user predictions should be scoped by competition => prediction -> match -> group -> round -> competition
    # predictions.where(competition: competition).count(&:correct?) * 3
    competition.predictions.count(&:correct?) * 3
  end
end
