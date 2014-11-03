class HomeController < ApplicationController
  before_filter :check_memes
  def foo
    @meme1 = Meme.where(name: "good1").first
  end

  def bar
    @meme2 = Meme.where(name: "good2").first
  end

  def baz
    @meme3 = Meme.where(name: "good3").first
  end
protected
  def check_memes
    if Meme.all.count < 3
      @meme1 = Meme.create name: "good1"
      @meme2 = Meme.create name: "good2"
      @meme3 = Meme.create name: "good3"
    end
  end
end
