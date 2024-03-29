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

  validates :name, presence: true, on: :update, if: :name_changed?

  after_create :auto_join_leaderboards

  def name
    super || email.split('@').first
  end

  private

  def auto_join_leaderboards
    DatabaseViews.run_without_callback(then_refresh: true) do
      Leaderboard.auto_join.each do |leaderboard|
        leaderboard.memberships.create(user: self)
      end
    end
  end
end
