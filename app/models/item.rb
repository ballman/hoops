class Item
  attr_reader :body
  attr_reader :posted_on

  FAKE_DATABASE = []
  
  def initialize(body)
    @body = body
    @posted_on = Time.now
    FAKE_DATABASE.unshift(self)
  end

  def self.find_recent
    FAKE_DATABASE
  end

  #populate with initial items
  new("Feed cat")
  new("Wash car")
  new("Sell start-up to google")
end
