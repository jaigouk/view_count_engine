require 'test_helper'

describe PrEngine::ViewCount do
  before do
    Meme.delete_all
    PrEngine::ViewCount.delete_all
    new_time = Time.local(2008, 9, 1, 15, 0, 0)
    Timecop.freeze(new_time)
    @v0 = PrEngine::ViewCount.create count: 24, created_at: 50.days.ago
    @v0 = PrEngine::ViewCount.create count: 214, created_at: 40.days.ago

    @v10 = PrEngine::ViewCount.create count: 4, created_at: 18.days.ago
    @v11 = PrEngine::ViewCount.create count: 6, created_at: 17.days.ago

    @v12 = PrEngine::ViewCount.create count: 8, created_at: 10.days.ago
    @v13 = PrEngine::ViewCount.create count: 3, created_at: 9.days.ago
    @v14 = PrEngine::ViewCount.create count: 1, created_at: 8.days.ago


    @v20 = PrEngine::ViewCount.create count: 104, created_at: 3.days.ago
    @v21 = PrEngine::ViewCount.create count: 4, created_at: 1.day.ago
    @v22 = PrEngine::ViewCount.create count: 5, created_at: 1.day.ago
    @v23 = PrEngine::ViewCount.create count: 2, created_at: 1.hour.ago
    @v24 = PrEngine::ViewCount.create count: 6, created_at: 10.minutes.ago
  end

  it "can return sum of view counts by date" do
    PrEngine::ViewCount.by_date_count(1.day.ago, "UTC").must_equal 9
    PrEngine::ViewCount.by_date_count(1.minute.ago, "UTC").must_equal 8

  end

  it "can return sum of view counts for a week" do
    PrEngine::ViewCount.total_count_by_week_from(Time.now, "UTC").must_equal 121
    options = {interval: "all", ago: "week", timezone: "UTC"}
    PrEngine::ViewCount.count_all(options).must_equal 121
  end

  it "can return all with sum of view counts for a week" do
    a = PrEngine::ViewCount.by_weekly_count_for(Time.now, 3, "UTC")
    a[0][:count].must_equal 121
    a[1][:count].must_equal 12
    a[2][:count].must_equal 10
    options = {interval: "weekly", ago: 3, timezone: "UTC"}
    b = PrEngine::ViewCount.count_all(options)
    b[0][:count].must_equal 121
    b[1][:count].must_equal 12
    b[2][:count].must_equal 10
  end

  it "can return sum of daily count for a week" do
    a = PrEngine::ViewCount.by_daily_count_for_a_week(Time.now, "UTC")
    a[0][:count].must_equal 8
    a[1][:count].must_equal 9
    a[2][:count].must_equal 0
    a[3][:count].must_equal 104
    options = {interval: "daily", ago: "week", timezone: "UTC"}
    b = PrEngine::ViewCount.count_all(options)
    b[0][:count].must_equal 8
    b[1][:count].must_equal 9
    b[2][:count].must_equal 0
    b[3][:count].must_equal 104
  end

  it "can return view counts for last 30 days(month)" do
    a = PrEngine::ViewCount.by_daily_count_for(Time.now, 30, "UTC")
    a[0][:count].must_equal 8
    a[1][:count].must_equal 9
    a[2][:count].must_equal 0
    a[3][:count].must_equal 104
    a[8][:count].must_equal 1
    a[9][:count].must_equal 3
    a[10][:count].must_equal 8
    a[17][:count].must_equal 6
    a[18][:count].must_equal 4
    a[28][:count].must_equal 0
    a[30].must_equal nil
    options = {interval: "daily", ago: 30, timezone: "UTC"}
    b = PrEngine::ViewCount.count_all(options)
    b[0][:count].must_equal 8
    b[1][:count].must_equal 9
    b[2][:count].must_equal 0
    b[3][:count].must_equal 104
    b[8][:count].must_equal 1
    b[9][:count].must_equal 3
    b[10][:count].must_equal 8
    b[17][:count].must_equal 6
    b[18][:count].must_equal 4
    b[28][:count].must_equal 0
    b[30].must_equal nil
  end

  it "can return sum of view counts by monthly" do
    a = PrEngine::ViewCount.by_monthly_count_for(from = Time.now, number_of_months=3, timezone="Pacific Time (US & Canada)")
    a[0][:count].must_equal 143
    a[1][:count].must_equal 238
    a[2][:count].must_equal 0
    a[3].must_equal nil
  end

end
