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

  # These are hard-coded/uploaded via rake task: rails user:upload_photos
  DEFAULT_AVATARS = %w[
    diaz
    gyokeres
    haaland
    hakimi
    kane
    kubo
    lukaku
    mane
    mbappe
    messi
    modric
    neymar
    ochoa
    pulisic
    robertson
    ronaldo
    ruediger
    salah
    son
    virgil
    yamal
  ].freeze

  validates :name, presence: true, on: :update, if: :name_changed?

  before_validation :assign_default_avatar, on: :create
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

  def self.need_prediction_notifications(round, match_ids: nil)
    return [] if round.blank?

    match_ids ||= round.matches.pluck(:id)
    users = round.competition.users_predicted.with_email_prediction_missing
    users.where.not(
      id: joins(:predictions)
            .where(predictions: { match_id: match_ids })
            .group('users.id')
            .having('COUNT(predictions.id) = ?', match_ids.count)
    )
  end

  private

  def assign_default_avatar
    self.photo_key = DEFAULT_AVATARS.sample if photo_key.blank?
  end

  def auto_join_leaderboards
    DatabaseViews.run_without_callback(then_refresh: true) do
      Leaderboard.auto_join.each do |leaderboard|
        leaderboard.memberships.create(user: self)
      end
    end
  end
end
