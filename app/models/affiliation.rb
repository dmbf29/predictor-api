class Affiliation < ApplicationRecord
  belongs_to :team
  belongs_to :group
end
