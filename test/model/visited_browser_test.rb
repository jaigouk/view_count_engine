require 'test_helper'

describe PrEngine::VisitedBrowser do

  before do
    Meme.delete_all
    PrEngine::ViewCount.delete_all
    PrEngine::ViewLocation.delete_all
    PrEngine::VisitedBrowser.delete_all
    @c1 = Meme.create name: "first"
    @c2 = Meme.create name: "second"
  end

  it "can be added at countable as temp data" do
    @c1.reset_view_count!
    @c1.add_browser("chorme:3:true")
    @c1.add_browser("chorme:4:false")
    @c1.increase_view_count
    @c1.increase_view_count
    @c1.temp_browsers.include?("chorme:3:true").must_equal true
    @c1.temp_browsers.include?("chorme:4:false").must_equal true
  end

  it "will not be added as temp data to countable if it is invalid" do
    @c2.add_browser("chorme:3")
    @c2.add_browser("chorme4:false")
    @c2.increase_view_count
    @c2.increase_view_count
    @c2.temp_browsers.include?("chorme:3").must_equal false
    @c2.temp_browsers.include?("chorme4:false").must_equal false
    @c2.temp_browsers.size.must_equal 0
  end

  it "will be created when flushed" do
    @c1.add_browser("chorme:3:true")
    @c1.add_browser("chorme:4:false")
    @c1.increase_view_count
    @c1.increase_view_count
    @c1.temp_browsers.include?("chorme:3:true").must_equal true
    @c1.temp_browsers.include?("chorme:4:false").must_equal true
    Meme.flush_counts!
    @c1.view_counts.first.visited_browsers.size.must_equal 2
  end
end
