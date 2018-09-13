module Blockchainable
  extend ActiveSupport::Concern

  private

  def blockchain_transaction!
    data = case controller_name
    when "items"
      item = @item

      case action_name
      when "create"
        {
          from: current_user_or_company,
          action: :create_item,
          item: item
        }
      else
      end

    when "services"
      service = @service
      item = service.item

      case action_name
      when "approve"
        {
          from: current_user_or_company,
          action: :approve_service,
          item: item,
          service: service
        }
      else
      end

    else
    end

    if data.present?
      tx_record = BlockchainTransactionDatum.create(data)
      BlockchainTxWorker.perform_async(tx_record.id) if tx_record.persisted?
    end
  end
end
