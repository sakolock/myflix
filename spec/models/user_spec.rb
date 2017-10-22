require 'spec_helper'

describe User do
  it { should have_many(:reviews)}
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name)}
  it { should validate_uniqueness_of(:email)}
  it { should have_many(:queue_items).order("position ASC")}
  it { should have_many(:reviews).order("created_at DESC")}

  describe '#queued_video?' do
    it 'returns true when the user queued the video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end
    it 'returns false when the user has not queued the video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be false
    end
  end

  describe '#follows?' do
    it 'returns true if the user has a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be true
    end
    it 'returns false if the user does not have a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.follows?(bob)).to be false
    end
  end
end
