# frozen_string_literal: true

require "spec_helper"

RSpec.describe Repositories::Transactions do
  let(:repo) { described_class.new }
  let(:stores_relation) { Lib[:rom].relations[:stores] }
  let(:transactions_relation) { Lib[:rom].relations[:transactions] }

  let(:params) do
    [
      {
        amount: 10,
        type: "some-type",
        identity_number: 1,
        card_number: 1,
        timestamp: Time.now,
        store: { name: "Loja 1", owner: "Dono 1" }
      },
      {
        amount: 20,
        type: "some-type",
        identity_number: 2,
        card_number: 2,
        timestamp: Time.now,
        store: { name: "Loja 1", owner: "Dono 1" }
      },
      {
        amount: 30,
        type: "some-type",
        identity_number: 3,
        card_number: 3,
        timestamp: Time.now,
        store: { name: "Loja 2", owner: "Dono 2" }
      }
    ]
  end

  describe "#create_with_store" do
    it "creates transactions and stores" do
      expect { repo.create_with_store(params) }
        .to change(stores_relation, :count).by(2)
        .and change(transactions_relation, :count).by(3)
    end

    context "when some store already exists" do
      it "creates the transactions and new stores" do
        store = Factory[:store, name: "Loja 2", owner: "Dono 2"]

        expect { repo.create_with_store(params) }
          .to change(stores_relation, :count).by(1)
          .and change(transactions_relation, :count).by(3)
          .and change(transactions_relation.where(store_id: store.id), :count).by(1)
      end
    end
  end
end
