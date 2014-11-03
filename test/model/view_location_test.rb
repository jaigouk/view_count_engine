require 'test_helper'

describe PrEngine::ViewLocation do
  before do
    Meme.delete_all
    PrEngine::ViewCount.delete_all
    PrEngine::ViewLocation.delete_all
    @e1 = Meme.create name: "first"
    @e2 = Meme.create name: "second"
    @e3 = Meme.create name: "third"
    # https://ipdb.at/city/US-Palo_Alto
    palo_alto = ["69.171.228.251", "69.171.232.165", "69.171.239.12", "173.252.112.23"]
    # https://ipdb.at/city/US-Seattle
    seattle = ["208.67.49.148", "208.115.113.88"]
    # https://ipdb.at/reg/GB-London
    london = ["92.40.253.210", "193.109.254.24", "95.154.230.254", "92.40.254.29", "213.199.149.229", "94.229.64.146"]
    palo_alto.each do |ip|
      @e1.add_view_ip(ip)
      @e1.increase_view_count
    end
    seattle.each do |ip|
      @e2.add_view_ip(ip)
      @e2.increase_view_count
    end
    london.each do |ip|
      @e3.add_view_ip(ip)
      @e3.increase_view_count
    end
    Meme.flush_counts!
    PrEngine::ViewLocation.create_indexes
  end
  it "will create view location objects after flushing countables" do
    c = @e1.view_counts.first
    c.view_locations.count.must_equal 4
    d = @e2.view_counts.first
    d.view_locations.count.must_equal 2
    e = @e3.view_counts.first
    e.view_locations.count.must_equal 6
  end

  it "each view location has coordinates" do
    c = @e1.view_counts.first
    c.view_locations.each do |l|
      l.coordinates[0].class.must_equal Float
      l.coordinates[1].class.must_equal Float
    end
  end

  it "saves city_name and timezone" do
    c = @e2.view_counts.first
    c.view_locations.each do |l|
      l.city_name.wont_be_nil
      l.postal_code.wont_be_nil
      l.timezone.wont_be_nil
      l.real_region_name.wont_be_nil
    end
  end

  it "can search counts that are happend nearby" do

    PrEngine::ViewLocation.near_from(-122.18260000000001, 37.37620000000001, 1).count.must_equal 4

    PrEngine::ViewLocation.near_from(-122.2995, 47.5839, 1).count.must_equal 2

    PrEngine::ViewLocation.near_from(-0.09309999999999263, 51.51419999999999, 1).count.must_equal 6
  end
end
