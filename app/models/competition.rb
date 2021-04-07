class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :rounds, dependent: :destroy
  has_many :groups, through: :rounds
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leagues, dependent: :destroy
  # TODO: Technically a User doesn't need to join a league to be involved in a competition
  # has_many :memberships, through: :leagues
  # has_many :users, through: :memberships
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
