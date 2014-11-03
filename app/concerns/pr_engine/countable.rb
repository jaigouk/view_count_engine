require "mongoid"
require "pr_engine/engine"
require "active_support/notifications"
require 'active_support/concern'
require 'redis-objects'

# http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html
module PrEngine
  module Countable
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Redis::Objects
      counter :temp_view_counter, :start => 0
      list :view_ip_list
      list :browser_list
      has_many :view_counts, as: :countable, class_name: 'PrEngine::ViewCount'

      def add_view_ip(ip)
        unless self.view_ip_list.include? ip
          ip = "118.33.50.69" if ip == "127.0.0.1"
          self.view_ip_list << ip unless self.temp_view_ip_list.include? ip
        end
      end

      def add_browser(browser)
        splited = browser.split(":")
        if (browser.class.to_s == "String") && (splited.size ==3) && !(/^[0-9]+$/.match(splited[1].gsub(".","")).nil?)
          self.browser_list << browser
        end
      end

      def temp_browsers
        self.browser_list.values
      end

      def temp_view_ip_list
        self.view_ip_list.values
      end

      def increase_view_count
        self.temp_view_counter.increment
      end

      def increase_view_count_with_ip(ip)
        self.temp_view_counter.increment
        self.add_view_ip(ip) unless ip.nil?
      end

      def increase_view_count_with_ip_user_agent(ip, user_agent)
        browser = Browser.new(:ua => user_agent)
        self.temp_view_counter.increment
        self.add_view_ip(ip) unless ip.nil?
        self.add_browser("#{browser.name}:#{browser.version}:#{browser.mobile?}")
      end

      def temp_view_count
        self.temp_view_counter.to_i
      end

      def reset_view_count!
        self.temp_view_counter.reset
        self.view_ip_list.clear
        self.browser_list.clear
      end

      def view_count
        self.view_counts.sum(:count)
      end

      def self.flush_counts!
        now = Time.now
        puts "^^^^^^^^^^^^^^^^^^^^^^^^"
        puts "| FLUSHING VIEW COUNTS |"
        puts "^^^^^^^^^^^^^^^^^^^^^^^^"
        # need to create view_count if count is bigger than 0
        self.each do |e|

          count = e.view_counts.create klass: e.class.to_s.downcase, count: e.temp_view_count, created_at: now

          if count
            e.temp_view_ip_list.each {|ip| count.view_locations.create ip: ip}
            e.temp_browsers.each do |data|
              info = data.split(':')
              mobile_info = info[2].include?("false") ? false : true
              count.visited_browsers.create name: info[0], version: info[1], mobile: mobile_info
            end
          end
          e.reset_view_count!
        end
      end
    end
  end # END OF COUNTABLE MODULE

end
