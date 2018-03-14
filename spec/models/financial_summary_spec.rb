require 'rails_helper'

describe FinancialSummary do
  let(:user) {create(:user)}

  context 'when summarizing over one day' do
    subject { FinancialSummary.one_day(user: user, currency: :usd) }

    before do
      Timecop.freeze(Time.now) do
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end

      Timecop.freeze(2.days.ago) do
        create(:transaction, user: user, category: :deposit)
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end
    end

    it 'returns deposit count' do
      expect(subject.count(:deposit)).to eq(2)
    end

    it 'returns the total deposit' do
      expect(subject.amount(:deposit)).to eq(Money.from_amount(12.12, :usd))
    end

    it 'returns withdrawls count' do
      expect(subject.count(:withdraw)).to eq(1)
    end

    it 'returns the total withdrawls' do
      expect(subject.amount(:withdraw)).to eq(Money.from_amount(1, :usd))
    end

    it 'returns refund count' do
      expect(subject.count(:refund)).to eq(1)
    end

    it 'returns the total refund' do
      expect(subject.amount(:refund)).to eq(Money.from_amount(2, :usd))
    end
  end

  context 'when summarizing over seven days' do
    subject { FinancialSummary.seven_days(user: user, currency: :usd) }

    before do
      Timecop.freeze(5.days.ago) do
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end

      Timecop.freeze(8.days.ago) do
        create(:transaction, user: user, category: :deposit)
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end
    end

    it 'returns deposit count' do
      expect(subject.count(:deposit)).to eq(2)
    end

    it 'returns total deposit' do
      expect(subject.amount(:deposit)).to eq(Money.from_amount(12.12, :usd))
    end

    it 'returns withdrawls count' do
      expect(subject.count(:withdraw)).to eq(1)
    end

    it 'returns the total withdrawls' do
      expect(subject.amount(:withdraw)).to eq(Money.from_amount(1, :usd))
    end

    it 'returns refund count' do
      expect(subject.count(:refund)).to eq(1)
    end

    it 'returns the total refund' do
      expect(subject.amount(:refund)).to eq(Money.from_amount(2, :usd))
    end
  end

  context 'when summarizing over lifetime' do
    subject { FinancialSummary.lifetime(user: user, currency: :usd) }

    before do
      Timecop.freeze(30.days.ago) do
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(2.12, :usd))
        create(:transaction, user: user, category: :deposit, amount: Money.from_amount(10, :usd))
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end

      Timecop.freeze(8.days.ago) do
        create(:transaction, user: user, category: :deposit)
        create(:transaction, user: user, category: :withdraw, amount: Money.from_amount(1, :usd))
        create(:transaction, user: user, category: :refund, amount: Money.from_amount(2, :usd))
      end
    end

    it 'returns deposit count' do
      expect(subject.count(:deposit)).to eq(3)
    end

    it 'returns total deposit' do
      expect(subject.amount(:deposit)).to eq(Money.from_amount(13.12, :usd))
    end

    it 'returns withdrawls count' do
      expect(subject.count(:withdraw)).to eq(2)
    end

    it 'returns the total withdrawls' do
      expect(subject.amount(:withdraw)).to eq(Money.from_amount(2, :usd))
    end

    it 'returns refund count' do
      expect(subject.count(:refund)).to eq(2)
    end

    it 'returns the total refund' do
      expect(subject.amount(:refund)).to eq(Money.from_amount(4, :usd))
    end
  end
end
