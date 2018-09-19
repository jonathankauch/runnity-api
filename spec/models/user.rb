# spec/models/user_spec.rb

require 'rails_helper'

# Prefix instance methods with a '#'
describe User, :type => :model do
  let!(:user){FactoryGirl.create(:user, email: "Toto@gmail.com", password: "azertyio")}

  context 'create a new user' do
     it '#check empty data' do
        expect(FactoryGirl.build(:user, email: nil, password: nil)).not_to be_valid
     end

     it '#check empty email' do
        expect(FactoryGirl.build(:user, email: nil, password: "azertyio")).not_to be_valid
     end

     it '#check wrong email format' do
        expect(FactoryGirl.build(:user, email: "abv")).not_to be_valid
     end

     it '#check duplicate email' do
        expect(FactoryGirl.build(:user, email: "Toto@gmail.com", password: "azertyio")).not_to be_valid
     end

     it '#check empty password' do
        expect(FactoryGirl.build(:user, email: "Tata@gmail.com", password: nil)).to be_valid
     end

    # it '#check short password' do
      #  expect(FactoryGirl.build(:user, email: "Tata@gmail.com", password: "abc")).not_to be_valid
    # end

     it '#check validate parameters' do
        expect(FactoryGirl.create(:user, email: "Tata@gmail.com", password: "azertyuio")).to be_valid
     end

     it '#check if possible to create user with admin status' do
        expect(user = FactoryGirl.create(:user, email: "Tata@gmail.com", password: "azertyuio", is_admin: true)).to be_valid
        expect(user.is_admin).to eq(true)
     end

     it '#check if possible to update user to admin' do
        user.update(is_admin: true)
        expect(user.is_admin).to eq(true)
     end
  end

  context '*Check data after creation' do
     it '#check user id' do
        expect(user.id).not_to eq(nil)
     end

     it '#check user email' do
        expect(user.email).not_to eq(nil)
     end

     it '#check user password' do
        expect(user.password).not_to eq(nil)
     end

     it '#check user create_at' do
        expect(user.created_at).not_to eq(nil)
     end

     it '#check user update_at' do
        expect(user.updated_at).not_to eq(nil)
     end

     it '#check user admin status' do
        expect(user.is_admin).to eq(false)
     end
  end
end
