require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path } 

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end # end signin page

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }
      
      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }
    
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end # end after visiting another page
    end # end with invalid information

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',		href: users_path) }
      it { should have_link('Profile',		href: user_path(user)) }
      it { should have_link('Settings',		href: edit_user_path(user)) }
      it { should have_link('Sign out', 	href: signout_path) }
      it { should_not have_link('Sign in',	href: signin_path) }

      describe "followed by signout" do
	before { click_link "Sign out" }
	it { should have_link('Sign in') }
      end # end followed by signout
    end # end with valid information
  end # end signin

  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      it { should_not have_link('Profile',		href: user_path(user)) }
      it { should_not have_link('Settings',		href: edit_user_path(user)) }
      
      describe "should be able to visit signup page" do
        before { visit signup_path }

        it { should have_title('Sign Up') }
      end # end should be able to visit signup page

      describe "when attempting to visit a protected page" do
        before { visit edit_user_path(user) }

        it { should have_title('Sign in') }

        describe "after signing in" do
	  before { sign_in user }

	  it "should render the desired protected page" do
	   expect(page).to have_title('Edit user')
	  end # end should render the desired protected page

	  describe "when signing in again" do
	    before do
	      click_link "Sign out"
	      visit signin_path
	      sign_in user
	    end

	    it "should render the default (profile) page" do
	      expect(page).to have_title(user.name)
	    end # end should render the default (profile) page
	  end # end when signing in again

	  describe "should not be able to visit signup page" do
	    before { visit signup_path }

	    it { should have_content(user.name) }
          end # end should not be able to visit signup page
        end # end after signing in
      end # end when attempting to visit a protected page

      describe "in the Users controller" do
      
        describe "visiting the edit page" do
	  before { visit edit_user_path(user) }
	    it { should have_title('Sign in') }
        end # visiting the edit page

        describe "submitting to the update action" do
	  before { patch user_path(user) }
	  specify { expect(response).to redirect_to(signin_path) }
        end # submitting to the update action

        describe "visiting the user index" do
	  before { visit users_path }
	  it { should have_title('Sign in') }
        end # end visiting the user index

	describe "visiting the following page" do
	  before { visit following_user_path(user) }
	  it { should have_title('Sign in') }
	end # end visiting the following page

	describe "visiting the followers page" do
	  before { visit followers_user_path(user) }
	  it { should have_title('Sign in') }
	end # end visiting the followers page

      end # end in the Users controller 

      describe "in the Microposts controller" do
      
        describe "submitting to the create action" do
	  before  { post microposts_path }
	  specify { expect(response).to redirect_to(signin_path) }
        end # end submitting to the create action

        describe "submitting to the destroy action" do
	  before  { delete micropost_path(FactoryGirl.create(:micropost)) }
	  specify { expect(response).to redirect_to(signin_path) }
        end # end submitting to the destroy action
      end # end in the Microposts controller

      describe "in the Relationships controller" do

	describe "submitting to the create action" do
	  before  { post relationships_path }
	  specify { expect(response).to redirect_to(signin_path) }
	end # end submitting to the create action

	describe "submitting to the destroy action" do
	  before  { delete relationship_path(1) }
	  specify { expect(response).to redirect_to(signin_path) }
	end # end submitting to the destroy action

      end # end in the Relationships controller

    end # end for non-signed-in users

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
	before { get edit_user_path(wrong_user) }
	specify { expect(response.body).not_to match(full_title('Edit User')) }
	specify { expect(response).to redirect_to(root_url) }
      end # end submitting a GET request to the Users#edit action

      describe "submitting a PATCH request to the Users#update action" do
	before { patch user_path(wrong_user) }
	specify { expect(response).to redirect_to(root_url) }
      end # end sumbitting a PATCH request to the Users#update action

    end # end as wrong user

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
	before { delete user_path(user) }
	specify { expect(response).to redirect_to(root_url) }
      end # end submitting a DELETE request to the Users#destroy action
    end # end as non-admin user

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin, no_capybara: true }

      describe "submitting a DELETE request for themselves" do
	before { delete user_path(admin) }
	specify { expect(response).to redirect_to(root_url) }
      end # end submitting a DELETE request for themselves
    end # end as admin user
	
  end # end authorization

end # end Authentication
