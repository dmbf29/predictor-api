class Team < ApplicationRecord
  # TODO: home and away teams are on a match
  # has_many :matches
  has_many :affiliations
  has_many :groups, through: :affiliations
end
