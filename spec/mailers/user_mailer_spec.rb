require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  let(:user) { FactoryGirl.create(:user, {name: 'Michael Hartl', email: 'michael@example.com', activated: true}) }

  subject { page }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi " + user.name)
      expect(mail.body.encoded).to match(user.activation_token)
    end
  end
end
