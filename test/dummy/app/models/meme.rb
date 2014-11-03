class Meme
  include Mongoid::Document
  include PrEngine::Countable

  field :name, type: String

  require "csv"

  def to_csv
    [name, craeted_at].to_csv
  end
end
