class BlockchainTxWorker
  include Sidekiq::Worker

  def perform(tx_record_id)
    tx_record = BlockchainTransactionDatum.where(id: tx_record_id).first
    nodes.each do |(host, port)|
      response = Net::HTTP.post_form(
        URI::HTTP.build(host: host, port: port, path: '/transactions'),
        parameterize_hash(tx_record.to_blockchain_hash)
      )
      json = JSON.parse(response.body)
      tx_record.update(blockchain_hash: json["blockchain_hash"])
    end if tx_record.present?
  end

  private

  def nodes
    [
      [ "localhost", "9292" ]
    ]
  end

  def parameterize_hash(hsh)
    flat_hsh = arraize_hash(hsh)
    flat_hsh.map do |k, v|
      nested_keys = k[1..-1].join("][")
      nested_keys = "[#{nested_keys}]" if nested_keys.present?
      [ "#{ k.first }#{ nested_keys }", v ]
    end.to_h
  end

  def arraize_hash(hsh)
    hsh.reduce({}) { |memo, (k, v)|
      if v.is_a?(Hash)
        new_hsh = arraize_hash(v)
        new_hsh.each { |k2, v2| memo.merge!({ k2.unshift(k) => v2 }) }
      else
        memo.merge!({ [k] => v })
      end
      memo
    }
  end
end
