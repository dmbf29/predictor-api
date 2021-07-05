class Match < ApplicationRecord
  belongs_to :team_away, class_name: 'Team'
  belongs_to :team_home, class_name: 'Team'
  belongs_to :group, optional: true
  belongs_to :round, optional: true
  belongs_to :next_match, class_name: 'Match', optional: true
  has_many :predictions, dependent: :destroy
  has_many :users, through: :predictions
  validates :kickoff_time, presence: true
  validates :status, presence: true
  validates_uniqueness_of :kickoff_time, scope: %i[team_home team_away]
  validate :round_xor_group
  enum status: { upcoming: 'upcoming', started: 'started', finished: 'finished' }, _default: :upcoming

  def draw?
    return unless finished?

    team_home_score == team_away_score &&
    team_home_et_score == team_away_et_score &&
    team_home_ps_score == team_away_ps_score
  end

  def round
    super || group&.round
  end

  def winner
    return unless finished?
    return if draw?

    winner_side == 'home' ? team_home : team_away
  end

  def extra_time?
    team_home_et_score.present? && team_away_et_score.present?
  end

  def penalties?
    team_home_ps_score.present? && team_away_ps_score.present?
  end

  def winner_side
    return unless finished?
    return 'draw' if draw?

    home_wins = team_home_score > team_away_score
    home_wins = team_home_et_score > team_away_et_score if extra_time?
    home_wins = team_home_ps_score > team_away_ps_score if penalties?

    home_wins ? 'home' : 'away'
  end

  private

  def round_xor_group
    errors.add(:round_id, 'or Group (not both) must exist') unless group_id.present? ^ round_id.present?
  end
end
