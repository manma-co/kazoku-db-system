FactoryBot.define do
  factory :event_date do
    hold_date { Date.today }
    start_time { Time.current }
    end_time { Time.current + 8.hours }
    meeting_place { '東京駅' }
    emergency_contact { '09012345678' }
    is_first_time { false }
    information { 'information text' }
    is_amazon_card { false }
    # user_id
    # study_abroad_id
  end
end
