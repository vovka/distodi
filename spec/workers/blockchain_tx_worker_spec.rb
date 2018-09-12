require "spec_helper"

describe BlockchainTxWorker do
  describe "#perform" do
    it "makes POST request with proper parameters" do
      worker = BlockchainTxWorker.new
      user = create :user
      item = create :item, user: user
      service = create :service, item: item, price: 123, id_code: "some code"
      tx = create :blockchain_transaction_datum, from: user, item: item, service: service
      stub_request(:post, "http://localhost:9292/transactions").with(body:
        hash_including(
          "action",
          "item" => hash_including(
            "id",
            "user_id",
            "user_type",
            "transferring_to_id",
            "category" => hash_including(
              "id"
            )
          ),
          "service" => hash_including(
            "id",
            "created_at",
            "updated_at",
            "next_control",
            "price",
            "status",
            "reason",
            "id_code",
            "comment",
            "approver_type",
            "item" => hash_including(
              "id",
              "user_id",
              "user_type",
              "transferring_to_id",
              "category" => hash_including(
                "id"
              )
            ),
            "action_kind" => hash_including(
              "id"
            )
          )
        )
      ).to_return(body: {blockchain_hash: "some hash"}.to_json)

      result = worker.perform(tx.id)

      expect(a_request(:post, "http://localhost:9292/transactions")).to have_been_made
    end
  end
end
