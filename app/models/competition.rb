class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :rounds
  has_many :groups, through: :rounds
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leagues
  # TODO: Technically a User doesn't need to join a league to be involved in a competition
  # has_many :memberships, through: :leagues
  # has_many :users, through: :memberships
end
