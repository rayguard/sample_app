require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

  describe "as another user" do
      before do
        another_user = FactoryGirl.create(:user, email: "another@user.com")
        visit signin_path
        valid_signin another_user
        visit user_path(user)
      end

      it { should_not have_link('delete', 
                                href: micropost_path(user.microposts.first.id)) }
    end
  end

  describe "micropost display" do
    before do
      50.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        user.microposts.paginate(page: 1).each do |m|
          page.should have_selector("li##{m.id}", text: m.content)
        end
      end
    end
  end
end