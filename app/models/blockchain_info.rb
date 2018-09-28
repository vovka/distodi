class BlockchainInfo
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
    res = Net::HTTP.get( URI("http://localhost:9292/transaction?hash=#{@hash}") )
    @block = res.presence && JSON.parse(res)
  end

  def to_s
    JSON.pretty_generate(@block.to_h)
  end
end
