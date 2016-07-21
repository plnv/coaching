require 'rails_helper'


describe "Password reset page" do

  let(:user) { FactoryGirl.create(:user, {name: 'Michael Hartl', email: 'michael@example.com', activated: true}) }

  subject { page }

  it "click Submit for activated user" do
    visit new_password_reset_path
    fill_in 'Email', with: user.email
    click_button 'Submit'

    is_expected.to have_selector('div.alert.alert-info', text: 'Email sent with password reset instructions')
  end

  it "click Submit empty email" do
    visit new_password_reset_path
    click_button 'Submit'

    is_expected.to have_selector('div.alert.alert-danger', text: 'Email address not found')
  end

  it "click Update password" do
    user.create_reset_digest
    visit edit_password_reset_path(user.reset_token, email: user.email)
    fill_in 'Password', with: "asdasd"
    fill_in 'Confirmation', with: "asdasd"
    click_button 'Update password'

    is_expected.to have_selector('div.alert.alert-success', text: 'Password has been reset.')
  end
end
