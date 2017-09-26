require 'spec_helper'

describe ReviewsController do
  context 'with authenticated users' do

    let(:current_user) { Fabricate(:user) }
    before { session[:user_id] = current_user.id }

    context 'with valid inputs' do
      it 'redirects to the video show page' do
        video = Fabricate(:video)
        post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
        expect(response).to redirect_to video
      end
      it 'creates a review' do
        video = Fabricate(:video)
        post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
        expect(Review.count).to eq(1)
      end
      it 'creates a review associated with the video' do
        video = Fabricate(:video)
        post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
        expect(Review.first.video).to eq(video)
      end
      it 'creates a review associated with the signed in user' do
        video = Fabricate(:video)
        post :create, params: { review: Fabricate.attributes_for(:review), video_id: video.id }
        expect(Review.first.user).to eq(current_user)
      end
    end
    context 'with invalid inputs' do
      it 'does not create a view' do
        video = Fabricate(:video)
        post :create, params: { review: { rating: 3 }, video_id: video.id }
        expect(Review.count).to eq(0)
      end
      it 'renders the videos#show template' do
        video = Fabricate(:video)
        post :create, params: { review: { rating: 3 }, video_id: video.id }
        expect(response).to render_template 'videos/show'        
      end
      it 'sets the video' do
        video = Fabricate(:video)
        post :create, params: { review: { rating: 3 }, video_id: video.id }
        expect(assigns(:video)).to eq(video)
      end
      it 'sets the reviews' do
        video = Fabricate(:video)
        review = Fabricate(:review, video: video)
        post :create, params: { review: { rating: 3 }, video_id: video.id }
        expect(assigns(:reviews)).to match_array([review])
      end
    end
  end

  context 'with unauthenticated users' do
    it 'redirects to the sign_in_path' do
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)
      post :create, params: { review: { rating: 3 }, video_id: video.id }
      expect(response).to redirect_to sign_in_path
    end
  end
end
