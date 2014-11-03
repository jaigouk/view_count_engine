require 'test_helper'

describe PrEngine::Countable do
  before do
    Meme.delete_all
    PrEngine::ViewCount.delete_all
    @meme1 = Meme.create name: "first"
    @meme2 = Meme.create name: "second"
    @meme1.reset_view_count!
    @meme2.reset_view_count!
  end

  it "can reset temporary view count" do
    @meme1.increase_view_count
    @meme1.increase_view_count
    @meme1.increase_view_count
    @meme1.temp_view_count.must_equal 3
    @meme1.reset_view_count!
    @meme1.temp_view_count.must_equal 0
  end

  it "can increase redis temporary view counter by instance" do
    @meme1.increase_view_count
    @meme1.temp_view_count.must_equal 1

    @meme1.increase_view_count
    @meme1.temp_view_count.must_equal 2

    @meme2.increase_view_count
    @meme2.temp_view_count.must_equal 1

    @meme2.increase_view_count
    @meme2.temp_view_count.must_equal 2
  end

  it "can flush all temporary view counts" do

    @meme1.increase_view_count
    @meme1.increase_view_count

    @meme2.increase_view_count
    @meme2.increase_view_count

    Meme.flush_counts!
    @meme1.temp_view_count.must_equal 0
    @meme2.temp_view_count.must_equal 0
  end


  it "can save increased redis view count to db" do
    @meme1.increase_view_count
    @meme1.increase_view_count
    Meme.flush_counts!
    @meme1.view_counts.last.count.must_equal 2
  end

  it "can save total number of view counts" do
    @meme3 = Meme.create name: "third"
    @meme3.reset_view_count!
    @meme3.increase_view_count
    @meme3.increase_view_count
    @meme3.increase_view_count

    Meme.flush_counts!
    @meme3.view_count.must_equal 3

    @meme3.increase_view_count
    @meme3.increase_view_count

    Meme.flush_counts!
    @meme3.view_count.must_equal 5
  end

end
