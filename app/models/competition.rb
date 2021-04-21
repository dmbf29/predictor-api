class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :rounds, dependent: :destroy
  has_many :groups, through: :rounds
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leaderboards, dependent: :destroy
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
