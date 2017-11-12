shared_examples "require sign in" do
  it "redirects to the front page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require admin" do
  it 'redirects to the home page' do
    session[:user_id] = Fabricate(:user).id
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "generates a random token" do
    expect(:object).to be_present
  end
end
