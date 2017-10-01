shared_examples "require sign in" do
  it "redirects to the front page" do
    session[:user_id] = nil
    action
    response.should redirect_to sign_in_path
  end
end
