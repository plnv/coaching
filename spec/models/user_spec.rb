require 'rails_helper'


describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }



  describe "should be valid" do
    it { should be_valid }
  end

  describe "name should be present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "name should not be too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end



  describe "email should not be too long" do
    before { @user.name = "a" * 244 + "@example.com" }
    it { should_not be_valid }
  end

  describe "email should be present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user@..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end



  describe "password should be present (nonblank)" do
    before { @user.password = @user.password_confirmation = " " * 6 }
    it { should be_invalid }
  end

  describe "password should have a minimum length" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
  end
end
