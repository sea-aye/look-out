require 'spec_helper'

RSpec.describe Hash do
  describe '#compact' do
    it { expect({ a: 'a', b: nil }.compact).to eq(a: 'a') }
  end
end
