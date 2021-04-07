class Affiliation < ApplicationRecord
  belongs_to :team
  belongs_to :group
  validates_uniqueness_of :team, scope: :group
end
