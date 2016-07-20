require 'rails_helper'


describe 'User edit profile' do

  subject { page }
  let(:user) { FactoryGirl.create(:user, {name: 'Michael Hartl', email: 'michael@example.com', password: 'foobar', activated:true}) }
  let(:new_user) { FactoryGirl.create(:user, {name: 'New User', email: 'newuser@mail.com', password: 'barfoo'}) }

  describe 'with login' do
    before {
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      visit edit_user_path(user)
    }

    it 'expect to have' do
      is_expected.to have_content('Update your profile')
      is_expected.to have_title('Edit user')
      is_expected.to have_link('change', href: 'http://gravatar.com/emails')
    end

    it 'as invalid information' do
      fill_in 'Email', with: ''
      click_button 'Save changes'

      is_expected.to have_content('error')
    end

    it 'as valid information' do
      fill_in 'Name', with: "New User"
      fill_in 'Email', with: "new@user.com"
      click_button 'Save changes'

      is_expected.to have_title("New User")
      is_expected.to have_selector('div.alert.alert-success')
      is_expected.to have_link('Log out', href: logout_path)
      expect(user.reload.name).to eq "New User"
      expect(user.reload.email).to eq "new@user.com"
    end
  end

  describe 'without log in' do
    it 'expect redirect to log in' do
      visit edit_user_path(user)

      is_expected.to have_title('Log in')
      is_expected.to have_selector('div.alert.alert-danger')
    end
  end

  describe "with different user" do
    it 'expect redirect to root' do
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      visit edit_user_path(new_user)

      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end
  end

  describe "return to edit" do
    it 'after login' do
      visit edit_user_path(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'

      is_expected.to have_title('Edit user')
    end
  end
end
