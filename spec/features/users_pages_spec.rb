require 'rails_helper'


describe "Users pages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user, {name: 'Michael Hartl', email: 'michael@example.com', password: 'foobar'}) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "profile page" do
    before { visit user_path(user) }

    it { is_expected.to have_content(user.name) }
    it { is_expected.to have_title(user.name) }
  end

  describe "Sign up page" do
    let(:submit) { "Create my account" }
    before { visit signup_path }

    describe "expect to have form" do
      it { is_expected.to have_selector('form[action="/signup"]') }
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { is_expected.to have_title('Sign up') }
        it { is_expected.to have_content('error') }
        it { is_expected.to have_selector('#error_explanation', text: 'The form contains') }
        it { is_expected.to have_selector('.field_with_errors') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "expect create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { is_expected.to have_title(user.name) }
        it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end

    it "should have the content 'Sign up'" do
      expect(page).to have_content('Sign up')
    end

    it "should have the title 'Sign up'" do
      expect(page).to have_title("Sign up | Ruby on Rails Tutorial Sample App")
    end
  end



  describe "All users" do
    before do
      30.times { FactoryGirl.create(:user) }
      visit login_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Log in'
      visit users_path
    end

    it 'including pagination' do
      expect(page).to have_selector('div.pagination')
      expect(page).to have_selector('a', text: 'Next')

      User.paginate(page: 1).each do |user|
        expect(page).to have_selector('a', text: user.name)
      end
    end

    it 'delete users' do
      expect do
        click_link('delete', match: :first)
      end.to change(User, :count).by(-1)

      is_expected.to have_selector('div.alert.alert-success', text: 'User deleted')
      is_expected.to have_no_link('delete', href: user_path(admin))
    end
  end
end
