FactoryBot.define do
  factory :jwt_token do
    user
    token nil

    trait :expired do
      # NOTE: use with `build_stubbed`, otherwise it gets overriden
      token { JwtService.encode(sub: user.id, exp: 1.minute.ago) }
    end
  end
end
