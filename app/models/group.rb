class Group < ApplicationRecord
  belongs_to :round
  has_many :matches
  has_many :affiliations
  has_many :teams, through: :affiliations
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :round
end
