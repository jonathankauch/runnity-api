FactoryGirl.define do
  factory :run do |run|
    run.started_at {Time.now}
    run.src_latitude { Faker::Number.decimal(3, 6) }
    run.src_longitude { Faker::Number.decimal(3, 6)}
  end

end
