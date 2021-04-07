class League < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships
  # TODO: Do we create a membership for the owner? If not, we need another method for all
  has_many :users, through: :memberships
  validates :name, presence: true
  validates :password, presence: true
end
