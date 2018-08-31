require "rails_helper"
 RSpec.describe User, type: :model do
  user = FactoryBot.build(:user)
  user.skip_confirmation!
  user.save
  describe "validations" do
     it "email should not be nil" do
      expect(user.email).not_to be nil
    end
    it "email's format" do
      expect(user.email).to match /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
    end
    it "name should not be nil" do
      expect(user.name).not_to be nil
    end
    it "password should not be nil" do
      expect(user.password).not_to be nil
    end
    it "password's length must be 6 characters at least" do
      expect(user.password.length).to be >= 6
    end
  end
   describe "instance methods" do
    it "email slug" do
      expect(user.email_slug).to eq(email_slug user.email, user.id)
    end
  end
end
