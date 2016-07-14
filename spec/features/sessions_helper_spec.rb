require 'rails_helper'


describe 'Authentication' do

  subject { page }
  let(:login) {'Log in'}

  describe 'signin page' do
    before { visit login_path }

    it { is_expected.to have_content('Log in') }
    it { is_expected.to have_title('Log in') }
  end

  describe 'signin' do
    before { visit login_path }

    describe "expect to have form" do
      it { is_expected.to have_selector('form[action="/login"]') }
    end

    describe 'with invalid information' do
      before { click_button login }

      it { is_expected.to have_title('Log in') }
      it { is_expected.to have_selector('div.alert.alert-danger') }

      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { is_expected.to have_no_selector('div.alert.alert-danger') }
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user, {name:'Michael Hartl', email:'michael@example.com', password:"foobar"}) }

      before do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button login
      end

      it { is_expected.to have_title(user.name) }
      it { is_expected.to have_link('Profile', href: user_path(user)) }
      it { is_expected.to have_link('Log out', href: logout_path) }
    end
  end
  
end