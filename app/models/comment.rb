class Comment < ActiveRecord::Base
  belongs_to :post
  validates :body, length: {maximum:40}
end
