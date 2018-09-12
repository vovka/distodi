class BlockchainTransactionDatum < ActiveRecord::Base
  belongs_to :from, polymorphic: true
  belongs_to :item
  belongs_to :service

  def to_blockchain_hash
    {
      action: action,
      item: item.to_blockchain_hash,
      service: service.try(:to_blockchain_hash)
    }
  end

  def persisted
    blockchain_hash.present?
  end
end

# == Schema Information
#
# Table name: blockchain_transaction_data
#
#  id              :integer          not null, primary key
#  action          :string
#  blockchain_hash :string
#  from_id         :integer
#  from_type       :string
#  item_id         :integer
#  service_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_blockchain_transaction_data_on_from_type_and_from_id  (from_type,from_id)
#  index_blockchain_transaction_data_on_item_id                (item_id)
#  index_blockchain_transaction_data_on_service_id             (service_id)
#
