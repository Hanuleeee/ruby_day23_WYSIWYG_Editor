class Movie < ApplicationRecord
    mount_uploader :image_path, ImageUploader
    # belongs_to :user   # 이미 1:m 관계가 있음
    has_many :likes
    has_many :users, through: :likes
    has_many :comments
    
    paginates_per 8  # 한 페이지당 8개만 보여줌
end
