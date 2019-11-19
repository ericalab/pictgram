class Comment < ApplicationRecord
  validates :content, presence:true, length: { maximum: 150 }
  
  belongs_to :user
  belongs_to :topic
end
