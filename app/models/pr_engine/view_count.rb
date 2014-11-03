require "mongoid"
require "pr_engine/engine"
# http://stackoverflow.com/questions/16492713/how-can-i-filter-results-of-map-reduce-in-mongoid
module PrEngine
  class ViewCount
    include Mongoid::Document
    include Mongoid::Timestamps

    field :count, type: Integer, default: 0
    field :klass, type: String
    field :content, type: Hash
    belongs_to :countable, polymorphic: true
    has_many :view_locations, dependent: :destroy
    has_many :visited_browsers, dependent: :destroy

    before_destroy do |portfolio|
      target_id = portfolio.id
    end

    def self.count_all(options)
      if options[:interval] == "daily"
        if options[:ago] == "week"
          self.by_daily_count_for_a_week(Time.now, "UTC")
        else
          self.by_daily_count_for(Time.now, options[:ago].to_i, "UTC")
        end
      elsif options[:interval] == "weekly"
        self.by_weekly_count_for(Time.now, options[:ago].to_i, "UTC")
      elsif options[:interval] == "all"
        if options[:ago] == "week"
          self.total_count_by_week_from(Time.now, "UTC")
        end
      else
        nil
      end
    end

    def self.for_date(t, timezone="Pacific Time (US & Canada)")
      st = ActiveSupport::TimeZone[timezone].parse(t.to_s).beginning_of_day
      ed = ActiveSupport::TimeZone[timezone].parse(t.to_s).end_of_day
      self.where(:created_at.gte => st, :created_at.lte => ed)
    end

    def self.by_date_count(t, timezone="Pacific Time (US & Canada)")
      self.for_date(t,timezone).sum(:count)
    end

    def self.for_month(from = Time.now, timezone="Pacific Time (US & Canada)")
      st = ActiveSupport::TimeZone[timezone].parse((from.to_date - 30).to_s).beginning_of_day
      ed = st.at_end_of_month
      self.where(:created_at.gte => st, :created_at.lte => ed)
    end

    def self.for_week(from = Time.now, timezone="Pacific Time (US & Canada)")
      st = ActiveSupport::TimeZone[timezone].parse((from.to_date - 7).to_s).beginning_of_day
      ed = ActiveSupport::TimeZone[timezone].parse(from.to_s).end_of_day
      self.where(:created_at.gte => st, :created_at.lte => ed)
    end

    def self.total_count_by_week_from(from = Time.now, timezone="Pacific Time (US & Canada)")
      self.for_week(from, timezone).sum(:count)
    end

    def self.by_monthly_count_for(from = Time.now, number_of_months=3, timezone="Pacific Time (US & Canada)")
      result = []
      start_days = self.get_start_date_of_months_for(from, number_of_months)
      start_days.each do |d|
        result << {start: d, count: self.for_month(d, timezone).sum(:count)}
      end
      result
    end

    def self.by_weekly_count_for(from = Time.now, number_of_weeks=3, timezone="Pacific Time (US & Canada)")
      result = []
      start_days = self.get_start_date_of_weeks_for(from, number_of_weeks)
      start_days.each do |d|
        result << {start: d, count: self.for_week(d, timezone).sum(:count)}
      end
      result
    end

    def self.by_daily_count_for(from = Time.now, days = 7, timezone="Pacific Time (US & Canada)")
      result = []
      start_days = self.get_start_date_of_days_for(from, days)
      start_days.each do |d|
        result << {start: d, count: self.for_date(d, timezone).sum(:count)}
      end
      result
    end

    def self.by_daily_count_for_a_week(from = Time.now, timezone="Pacific Time (US & Canada)")
      self.by_daily_count_for(from = Time.now, 7, timezone="Pacific Time (US & Canada)")
    end

    def self.by_daily_count_for_a_month(from = Time.now, timezone="Pacific Time (US & Canada)")
      self.by_daily_count_for(from = Time.now, 30, timezone="Pacific Time (US & Canada)")
    end

    protected

    def self.get_start_date_of_months_for(start_date, number_of_months)
      result = []
      term = Range.new(0,number_of_months - 1)
      term.to_a.reverse.each do |month_offset|
          start_date = month_offset.months.ago.beginning_of_month
          result << start_date
          # end_date = month_offset.months.ago.end_of_month
          # puts "Start date : #{start_date} End date : #{end_date}"
      end
      result.reverse
    end

    def self.get_start_date_of_weeks_for(start_date, number_of_weeks)
      number_of_weeks.times.inject([]) { |memo, w| memo << start_date - w.weeks }
    end

    def self.get_start_date_of_days_for(start_date, number_of_days)
      number_of_days.times.inject([]) { |memo, w| memo << start_date - w.days }
    end

  end

end
