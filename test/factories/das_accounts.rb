FactoryBot.define do
  factory :das_account do
    domain { "MyString" }
    invite_domain { "MyString" }
    invite_id { 1 }
    start_at { "2021-11-05 22:50:30" }
    end_at { "2021-11-05 22:50:30" }
    is_list { false }
    list_time { "2021-11-05 22:50:30" }
  end
end
