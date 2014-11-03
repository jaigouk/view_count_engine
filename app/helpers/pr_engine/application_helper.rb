require 'browser'

module PrEngine
  module ApplicationHelper

    def count_exposure_for(instance)
      if instance.respond_to?(:increase_view_count)
        instance.increase_view_count
        ip = request.ip || request.env['HTTP_X_FORWARDED_FOR'].split(/,/).try(:first)
        instance.add_view_ip(ip)
      end
    end

    def able_to_show_svg?
      browser = Browser.new(:ua => request.user_agent)
      !(browser.mobile? || (browser.ie? && browser.version.to_i < 9))
    end
  end
end
