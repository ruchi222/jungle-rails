require 'rails_helper'

RSpec.describe User, type: :model do
  
  before(:each) do
    @user = User.new
  end

  it 'saves with all fields filled in' do
    full_user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
    full_user.save
    expect(full_user).to be_valid
  end
  
  it 'is invalid without a first_name' do
    expect(@user).to_not be_valid
    expect(@user.errors.messages[:first_name]).to include('can\'t be blank')
  end
  
  it 'is invalid without a last_name' do
    expect(@user).to_not be_valid
    expect(@user.errors.messages[:last_name]).to include('can\'t be blank')
  end

  it 'is invalid without password' do
    expect(@user).to_not be_valid
    expect(@user.errors.messages[:password]).to include('can\'t be blank')
  end

  it 'is invalid if password and password confirmation do not match' do
    full_user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
    full_user2 = User.new(first_name: 'b', last_name: 'a', email: 'email@email.com', password: 'apples', password_confirmation: 'APPLES')
    full_user.save
    full_user2.save
    expect(full_user.password).to eq(full_user.password_confirmation)
    expect(full_user2.password).to_not eq(full_user2.password_confirmation)
  end

  it 'is invalid if password is too short' do
    full_user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
    full_user2 = User.new(first_name: 'b', last_name: 'a', email: 'mail@mail.com', password: 'a', password_confirmation: 'a')
    full_user.save
    full_user2.save
    expect(full_user).to be_valid
    expect(full_user2).to_not be_valid
    expect(full_user2.errors.messages[:password]).to include("is too short (minimum is 6 characters)")
    expect(full_user2.errors.messages[:password_confirmation]).to include("is too short (minimum is 6 characters)")
  end

  it 'is invalid without an email' do
    expect(@user).to_not be_valid
    expect(@user.errors.messages[:email]).to include('can\'t be blank')
  end

  it 'requires a unique email' do
    full_user1 = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
    full_user2 = User.new(first_name: 'b', last_name: 'a', email: 'email@email.com', password: 'APPLES', password_confirmation: 'APPLES')
    full_user1.save
    full_user2.save
    expect(full_user1).to be_valid
    expect(full_user2).to_not be_valid
    expect(full_user2.errors.messages[:email]).to include('has already been taken')
  end

  context 'on an existing user' do
    let(:user) do
      full_user1 = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
      full_user1.save
      User.find full_user1.id
    end

    it "should be valid with no changes" do
      expect(user).to_not be_valid
    end

    it "should not be valid with an empty password" do
      user.password = user.password_confirmation = ""
      expect(user).to_not be_valid
    end

    it "should be valid with a new (valid) password" do
      user.password = user.password_confirmation = "new password"
      expect(user).to be_valid
    end
  end

  describe ".authenticate_with_credentials" do
    
    it 'should authenticate if password and email are valid' do
    user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
    user.save
    valid_user = User.authenticate_with_credentials('email@email.com', 'apples')

    expect(valid_user).to eq(user)
    end

    it 'should not authenticate if password and email are valid' do
      user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
      user.save
      invalid_user = User.authenticate_with_credentials('notemail@notemail.com', 'apples')
  
      expect(invalid_user).to_not eq(user)
    end

    it 'should authenticate if user adds uppercase letters to their email' do
      user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
      user.save
      valid_user = User.authenticate_with_credentials('EMAIL@email.com', 'apples')
      expect(valid_user).to eq(user)
    end

    it 'should authenticate if user adds spaces to beginning or end of email' do
      user = User.new(first_name: 'a', last_name: 'b', email: 'email@email.com', password: 'apples', password_confirmation: 'apples')
      user.save
      valid_user = User.authenticate_with_credentials(' email@email.com ', 'apples')
      expect(valid_user).to eq(user)
    end
  end
end

