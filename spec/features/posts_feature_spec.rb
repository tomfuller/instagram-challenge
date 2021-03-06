require 'rails_helper'

feature 'posts' do
  context 'no posts have been added' do
    scenario 'should display a prompt to add a post' do
      visit '/posts'
      expect(page).to have_content 'No posts yet'
      expect(page).to have_link 'Add a post'
    end
  end

  context 'posts have been added' do

    before do
      sign_up
      add_post
    end

    scenario 'display posts' do
      visit '/posts'
      expect(page).to have_content 'Beautiful day'
      expect(page).to have_css("img[src*='snow_and_sun.jpg']")
      expect(current_path).to eq '/posts'
      expect(page).not_to have_content 'No posts yet'
    end
  end

  context 'viewing posts' do

    scenario 'lets a user view the posts' do
      sign_up
      add_post
      click_link 'image'
      expect(page).to have_content 'Beautiful day'
      expect(page).to have_css("img[src*='snow_and_sun.jpg']")
    end

  end

  context 'editing posts' do

    scenario 'lets users edit their posts' do
      sign_up
      add_post
      click_link 'image'
      click_link 'Edit post'
      fill_in 'Caption', with: 'edited post'
      page.attach_file('post[image]', Rails.root + 'spec/fixtures/beach.jpg')
      click_button "Edit"
      expect(page).to have_content 'edited post'
      expect(page).to have_css("img[src*='beach.jpg']")
    end

    scenario 'another user cannot edit a users posts' do
      sign_up
      add_post
      click_link 'Sign out'
      sign_up2
      click_link 'image'
      expect(page).not_to have_link 'Edit post'
    end

  end

  context 'deleting posts' do

    scenario 'lets user delete their posts' do
      sign_up
      add_post
      click_link 'image'
      click_link 'Delete post'
      expect(current_path).to eq '/posts'
      expect(page).not_to have_content 'Beautiful day'
      expect(page).not_to have_css("img[src*='snow_and_sun.jpg']")
    end

    scenario 'another user cannot delete a users posts' do
      sign_up
      add_post
      click_link 'Sign out'
      sign_up2
      click_link 'image'
      expect(page).not_to have_link 'Delete post'
    end

  end

  context 'no user' do

    scenario 'user is not logged in so cannot post' do
      visit '/posts'
      click_link 'Add a post'
      expect(current_path).to eq '/users/sign_in'
    end

  end

end
