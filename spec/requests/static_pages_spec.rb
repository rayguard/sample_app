
require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end#close all static pages

  describe "Home page" do

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end#close before

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end#close user.feed.each
      end#close should render the user's feed

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end#close before

        it { should have_link("0 Following", href: following_user_path(user)) }
        it { should have_link("1 Followers", href: followers_user_path(user)) }
      end#close follower/following counts
    end#close for signed-in users
  

    before { visit root_path }
    let(:heading)    { 'My Chats' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end#close Home page

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'My Chats' }
    let(:page_title) { '' }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end#close Help page

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'My Chats' }
    let(:page_title) { '' }

    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end#close About page

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'My Chats' }
    let(:page_title) { '' }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end#close Contact page

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "My Chats"
    expect(page).to have_title(full_title(''))
  end#close should have the right links on the layout
end#close Static pages