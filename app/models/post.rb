class Post < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :description, length: { maximum: 500 }
end
