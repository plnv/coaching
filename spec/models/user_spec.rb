require 'rails_helper'


describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:admin) }
  it { is_expected.to respond_to(:microposts) }

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end

  describe "expected to be valid" do
    it { is_expected.to be_valid }
  end

  describe "name expected to be present" do
    before { @user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "name should not be too long" do
    before { @user.name = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "email addresses should be unique" do
    before do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      duplicate_user.save
    end
    it { is_expected.to be_invalid }
  end

  describe "email addresses should be saved as lower-case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    let(:lower_case_email) { "foo@example.com" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      expect {@user.save}.to change{@user.email}.from(mixed_case_email).to(lower_case_email)
    end
  end

  describe "email should not be too long" do
    before { @user.name = "a" * 244 + "@example.com" }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "expect to be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user@..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "expect to be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "password expected to be present (nonblank)" do
    before { @user.password = @user.password_confirmation = " " * 6 }
    it { is_expected.to be_invalid }
  end


  describe "password should not be too long" do
    before { @user.password = @user.password_confirmation = "a" *  73 }
    it { is_expected.to be_invalid }
  end

  describe "password should have a minimum length" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { is_expected.to be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { is_expected.to eq found_user.authenticate(@user.password) }
    end
  end
end
