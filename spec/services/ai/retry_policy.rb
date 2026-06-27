require 'rails_helper'

RSpec.describe Ai::RetryPolicy do
  it 'retries on transitient errors' do
    attempts = 0
    result = described_class.execute(delay_method: ->(seconds) { }) do
      attempts += 1
      raise Faraday::ServerError.new("500", { status: 500 }) if attempts < 3
      "success"
    end

    expect(result).to eq("success")
    expect(attempts).to eq(3)
  end

  it 'gives up after max attempts' do
    attempts = 0

    expect {
      described_class.execute(delay_method: ->(seconds) { }) do
        attempts += 1
        raise Faraday::ServerError.new("500", { status: 500 })
      end
     }.to raise_error(Faraday::ServerError)
    expect(attempts).to eq(3)
  end
end
