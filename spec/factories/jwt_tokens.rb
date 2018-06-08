FactoryBot.define do
  factory :jwt_token do
    user
    token nil
  end
end
