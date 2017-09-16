require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title function' do
    it 'returns an empty array if there is no match' do
      futurama = Video.create(title: 'Futurama', description: 'Great show')
      south_park = Video.create(title: 'South Park', description: 'Another great show')
      expect(Video.search_by_title('aal;kj')).to eq([])
    end

    it 'returns an array of one video if there is an exact match' do
      futurama = Video.create(title: 'Futurama', description: 'Great show')
      south_park = Video.create(title: 'South Park', description: 'Another great show')
      expect(Video.search_by_title('Futurama')).to eq([futurama])
    end

    it 'returns an array of one video if there is a partial match' do
      futurama = Video.create(title: 'Futurama', description: 'Great show')
      south_park = Video.create(title: 'South Park', description: 'Another great show')
      expect(Video.search_by_title('urama')).to eq([futurama])
    end

    it 'returns an array with multiple titles ordered by created_at if multiple matches' do
      futurama = Video.create(title: 'Futurama', description: 'Great show')
      south_park = Video.create(title: 'South Park', description: 'Another great show', created_at: 1.day.ago)
      expect(Video.search_by_title('ut')).to eq([futurama, south_park])
    end

    it 'returns an empty array if search_term is an empty string' do
      futurama = Video.create(title: 'Futurama', description: 'Great show')
      south_park = Video.create(title: 'South Park', description: 'Another great show', created_at: 1.day.ago)
      expect(Video.search_by_title('')).to eq([])
    end
  end
end
