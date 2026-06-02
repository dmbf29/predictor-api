class Email < ApplicationRecord
  belongs_to :user
  belongs_to :topic, polymorphic: true, optional: true
end
