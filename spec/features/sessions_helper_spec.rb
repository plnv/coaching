require 'rails_helper'


describe 'Authentication' do

  subject { page }

  it 'signin page' do
    visit login_path

    is_expected.to have_content('Log in')
    is_expected.to have_title('Log in')
  end

  let(:user) { FactoryGirl.create(:user, {name: 'Michael Hartl', email: 'michael@example.com', password: "foobar"}) }

  describe 'log in' do
    before { visit login_path }

    it "expect to have form" do
      is_expected.to have_selector('form[action="/login"]')
    end

    describe 'with invalid information' do
      it 'Log in' do
        click_button 'Log in'

        is_expected.to have_title('Log in')
        is_expected.to have_selector('div.alert.alert-danger', text: 'Invalid email/password combination')
      end

      it 'after visiting another page' do
        click_button 'Log in'
        click_link 'Home'

        is_expected.to have_no_selector('div.alert.alert-danger', text: 'Invalid email/password combination')
      end
    end

    describe 'with valid information' do
      it 'Log in' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'

        is_expected.to have_title(user.name)
        is_expected.to have_link('Profile', href: user_path(user))
        is_expected.to have_link('Log out', href: logout_path)
      end
    end
  end

  describe 'log out' do
    it 'expect to logout user' do
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      click_link 'Log out'

      is_expected.to have_link('Log in', href: login_path)
      is_expected.to have_no_link('Log out', href: logout_path)
    end

    it 'expect to forget user' do
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      check('session_remember_me')
      click_button 'Log in'
      click_link 'Log out'
      visit login_path

      expect(find('#session_remember_me')).to_not be_checked
    end
  end
end