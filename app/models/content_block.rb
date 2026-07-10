class ContentBlock < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
