require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  setup do
    Meme.delete_all
    PrEngine::ViewCount.delete_all
    @m1 = Meme.create name: "good1"
    @m2 = Meme.create name: "good2"
    @m3 = Meme.create name: "good3"
  end

  test "increase redis view counter by instance" do
     get main_app.home_bar_path
     get main_app.home_bar_path
     assert_match "Meme Count: 2", response.body
     get main_app.home_baz_path
     get main_app.home_baz_path
     get main_app.home_baz_path
     get main_app.home_baz_path
     assert_match "Meme Count: 4", response.body
  end
end

