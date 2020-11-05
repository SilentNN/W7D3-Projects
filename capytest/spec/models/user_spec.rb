require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:new_user) { FactoryBot.build(:user, username: "Joe", password: "asdf12") }

  describe 'validations' do

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:session_token) }
    it { should validate_length_of(:password).is_at_least(6) }

  end

  describe 'associations' do 

  end

  describe 'class methods' do 
    describe '#User::find_by_credentials' do 

      context 'user exists' do
        it 'returns correct user' do
          expect(User.find_by_credentials('Joe', 'asdf12')).to eq(:new_user)
        end
      end
    

      context 'user does not exist' do 
        it 'should return nil' do 
          expect(User.find_by_credentials('Walker', 'hellowalker')).to eq(nil)
        end
      end

    end

    describe '#password=' do 
      let(:user) {FactoryBot.build(:user, username: "Vanessa", password: "hunter12")}
      
      it "should create a password digest" do
        expect(user.password_digest).to_not be_nil
      end
    end
    
    describe '#is_password?' do 
      let(:user) {FactoryBot.build(:user, username: "Vanessa", password: "hunter12")}
      
      context "given correct password" do
        it "should return true" do
          expect(user.is_password?("hunter12")).to be true
        end
      end

      context "given incorrect password" do
        it "should return false" do
          expect(user.is_password?("gunter12")).to be false
        end
      end
    end

    describe '#reset_session_token!' do 
      it "should reset session token" do
        old_session_token = new_user.session_token
        expect(new_user.reset_session_token!).to_not eq(old_session_token)
      end
    end

    describe '#ensure_session_token' do 
      it "creates a session token before validation" do 
        expect(new_user.session_token).to_not be nil 
      end
    end
  end

end
