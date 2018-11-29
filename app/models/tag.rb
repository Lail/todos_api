class Tag < ApplicationRecord

  # no need for has_many :through at this point
  has_and_belongs_to_many :tasks

  validates :title, presence: true, length: { minimum: 1 }
end
