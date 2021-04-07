class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :memberships
  has_many :leagues, through: :memberships
  # has_many :leagues_as_owner, mod
  has_many :competitions, through: :leagues
  has_many :predictions
  has_many :matches, through: :predictions
end
