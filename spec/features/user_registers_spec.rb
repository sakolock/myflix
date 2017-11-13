require 'spec_helper'

feature 'User registers', { vcr: true, js: true } do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_valid_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in now.")
  end
  
  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Your card number is incomplete.")
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Invalid user information. Please check the errors below!")
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Your card number is incomplete.")
  end

  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card_info
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content("Invalid user information. Please check the errors below!")
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "john@example.com"
  end

  def fill_in_valid_card_info
    within_frame(find('iframe')) do
      find("input[name='cardnumber']").send_keys('4242424242424242')
      fill_in name: 'exp-date', with: '11/20'
      fill_in name: 'cvc', with: '123'
      fill_in name: 'postal', with: '90210'
    end
  end

  def fill_in_invalid_card_info
    within_frame(find('iframe')) do
      find("input[name='cardnumber']").send_keys('123')
      fill_in name: 'exp-date', with: '11/20'
      fill_in name: 'cvc', with: '123'
      # postal is not exposed if the above are invalid
    end
  end

  def fill_in_declined_card_info
    within_frame(find('iframe')) do
      find("input[name='cardnumber']").send_keys('4000000000000002')
      fill_in name: 'exp-date', with: '11/20'
      fill_in name: 'cvc', with: '123'
      fill_in name: 'postal', with: '90210'
    end
  end
end
