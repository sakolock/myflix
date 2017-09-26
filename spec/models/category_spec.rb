require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos function' do
    it 'returns an array of the videos in reverse chronological order by created_at' do
      c = Category.create(name: 'Bollywood')
      v1 = Video.create(title: 'Men in Black II', description: 'Great flick', category: c, created_at: 1.day.ago)
      v2 = Video.create(title: 'Men in Black I', description: 'Great flick', category: c)
      expect(c.recent_videos).to eq([v2, v1])
    end
    it 'returns all the videos if there are fewer than 6 videos' do
      c = Category.create(name: 'Bollywood')
      v1 = Video.create(title: 'Men in Black II', description: 'Great flick', category: c, created_at: 1.day.ago)
      v2 = Video.create(title: 'Men in Black I', description: 'Great flick', category: c)
      expect(c.recent_videos.count).to eq(2)
    end
    it 'returns 6 videos if there are more than 6 videos' do
      c = Category.create(name: 'Bollywood')
      7.times { Video.create(title: 'Vid!', description: 'Great vid!', category: c) }
      expect(c.recent_videos.count).to eq(6)
    end
    it 'returns the most recent 6 videos' do
      c = Category.create(name: 'Bollywood')
      6.times { Video.create(title: 'Vid!', description: 'Great vid!', category: c) }
      older_video = Video.create(title: 'Great Expectations', description: 'A good movie, bad book', category: c, created_at: 1.day.ago)
      expect(c.recent_videos).to_not include(older_video)
    end
    it 'returns an empty array if there are no videos' do
      c = Category.create(name: 'Bollywood')
      expect(c.recent_videos).to eq([])
    end
  end
end
