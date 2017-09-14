FactoryGirl.define do
  factory :geo_node do
    host { Gitlab.config.gitlab.host }
    sequence(:port) {|n| n}
    association :geo_node_key

    trait :primary do
      primary true
      port { Gitlab.config.gitlab.port }
      geo_node_key nil
    end

    trait :current do
      port { Gitlab.config.gitlab.port }
    end
  end
end
