FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user # this tells Factory Girl about the micropost's associated user
	 # just by including a user in the factory definition
	 # this allows us to define factory microposts in this manner:
	 # FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
  end

end
