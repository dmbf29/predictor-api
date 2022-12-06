class MatchResult < ScenicViewRecord
  belongs_to :match
  belongs_to :group, optional: true
  belongs_to :round
  belongs_to :competition
  belongs_to :team_home, class_name: 'Team'
  belongs_to :team_away, class_name: 'Team'

  enum status: { upcoming: 'upcoming', started: 'started', finished: 'finished' }
end
