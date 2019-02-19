class BlockchainInfo
  DEMO_SERVICE_HASH = "notrealdemohash".freeze

  delegate :[], to: :"@block"

  def initialize(hash)
    @hash = hash
  end

  def self.get_info(hash)
    instance = new(hash)
    instance.load
    instance
  end

  def load
    if DEMO_SERVICE_HASH == @hash
      @block = demo_hash
    else
      res = Net::HTTP.get( URI("http://localhost:9292/transaction?hash=#{@hash}") )
      @block = res.presence && JSON.parse(res)
    end
  end

  def to_s
    JSON.pretty_generate(@block.to_h)
  end

  private

  def demo_hash
    {
      "transaction" => {
        "hash" => DEMO_SERVICE_HASH * 4,
        "timestamp" => Time.current
      }
    }
  end
end
