require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
	expect { click_button "Post"}.not_to change(Micropost, :count)
      end # end should not create a micropost

      describe "error messages" do
	before { click_button "Post" }
	it { should have_content('error') }
      end # end error messages
    end # end with invalid information

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }

      it "should create a micropost" do
	expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end # end should create a micropost
    end # end with valid information
  end # micropost creation

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end # end should delete a micropost
    end # as correct user
  end # micropost destruction
end # end MicropostPages
