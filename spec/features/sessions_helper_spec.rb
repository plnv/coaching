require 'rails_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit login_path }

    it { is_expected.to have_content('Log in') }
    it { is_expected.to have_title('Log in') }
  end
end