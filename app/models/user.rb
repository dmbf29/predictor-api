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
  has_many :emails, dependent: :destroy

  # Scenic views
  has_many :scores, class_name: 'UserScore'

  scope :with_email_prediction_missing, -> {
    where("notifications->'email'->>'prediction_missing' = ?", 'true')
  }

  validates :name, presence: true, on: :update, if: :name_changed?

  after_create :auto_join_leaderboards

  def name
    super || email.split('@').first
  end

  # user.notification_enabled?(:email, :prediction_missing)
  # (query) User.where("notifications->'email'->>'prediction_missing' = ?", 'true')
  def notification_enabled?(method, event)
    notifications.dig(method.to_s, event.to_s) || false
  end

  # user.enable_notification!(:email, :prediction_missing)
  def enable_notification!(method, event)
    self.notifications[method.to_s] ||= {}
    self.notifications[method.to_s][event.to_s] = true
    save
  end

  # user.disable_notification!(:email, :prediction_missing)
  def disable_notification!(method, event)
    self.notifications[method.to_s] ||= {}
    self.notifications[method.to_s][event.to_s] = false
    save
  end

  def self.need_prediction_notifications(next_match)
    return [] if next_match.blank?

    # total number of people who have made predicitons (and have email on)
    users = next_match.competition.users_predicted.with_email_prediction_missing
    # minus the ones who have made predictions for this match
    users - users.joins(:predictions).where(predictions: { match_id: next_match.id })
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
