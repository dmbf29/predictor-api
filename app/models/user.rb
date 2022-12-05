class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable # :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :memberships, dependent: :destroy
  has_many :leaderboards, through: :memberships
  # TODO: Fix this
  # has_many :competitions, through: :leaderboards
  has_many :predictions, dependent: :destroy
  has_many :matches, through: :predictions

  # Scenic views
  has_many :scores, class_name: 'UserScore'
  has_many :match_results
  has_many :leaderboard_rankings

  validates :name, presence: true, on: :update, if: :name_changed?

  def display_name
    name || email.split('@').first
  end
end
