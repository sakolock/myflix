class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  has_many :queue_items,-> { order 'position ASC' }
  has_many :reviews,-> { order 'created_at DESC' }
  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship'
  has_many :leading_relationships, foreign_key: 'leader_id', class_name: 'Relationship'

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end 

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def deactivate!
    update_column(:active, false)
  end
end
