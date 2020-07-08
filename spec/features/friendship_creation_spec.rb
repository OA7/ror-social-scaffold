require 'rails_helper'

RSpec.feature 'Friendships', type: :feature do
  let(:user1) do
    User.create(name: 'Jay', email: 'jay@jay.com', password: '000000', password_confirmation: '000000')
  end
  let(:user2) do
    User.create(name: 'Kay', email: 'kay@kay.com', password: '000000', password_confirmation: '000000')
  end

  before :each do
    user1
    user2
    visit 'users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: 'jay@jay.com'
      fill_in 'user_password', with: '000000'
    end
    click_button 'commit'
    visit '/users'
  end

  it 'allows a user to send a friend requests to another user' do
    expect(page).to have_content('Send Friend Request')
  end

  it 'allows a user to accept a friend request from another user' do
    Friendship.create(user_id: user2.id, friend_id: user1.id, status: -1)
    click_link(user1.name)
    expect(page).to have_content('Accept Friend Request')
  end

  it 'allows a user to reject a friend requests from another user' do
    Friendship.create(user_id: user2.id, friend_id: user1.id, status: -1)
    click_link(user1.name)
    expect(page).to have_content('Reject Friend Request')
  end
end
