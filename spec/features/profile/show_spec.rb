require 'rails_helper'

RSpec.describe 'Profile' do
  describe 'As a User' do
    it "I see my profile page" do
      user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit '/profile'
      within '#profile' do
        expect(page).to have_content("Username: #{user.name}")
        expect(page).to have_content("Address: #{user.address}")
        expect(page).to have_content(user.city)
        expect(page).to have_content(user.state)
        expect(page).to have_content(user.zip)
        expect(page).to have_content("Email: #{user.email}")
      end

    end
  end
end
