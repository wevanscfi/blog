class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  def dumb
    return "dedoo"
  end
end

