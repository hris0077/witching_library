require "rails_helper"

RSpec.describe Ai::Config do
  it "allows dynamic configuration" do
    described_class.configure do |config|
      config.llm_max_tokens = 500
    end

    expect(described_class.llm_max_tokens).to eql(500)
  end

  it "returns nil for undefined settings" do
    expect(described_class.undefined_setting).to be_nil
  end
end
