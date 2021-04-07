class Membership < ApplicationRecord
  belongs_to :league
  belongs_to :user
  validates_uniqueness_of :user, scope: :league
end
