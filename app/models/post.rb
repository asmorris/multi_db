# frozen_string_literal: true

class Post < UserScopedRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :description, length: { maximum: 500 }
end
