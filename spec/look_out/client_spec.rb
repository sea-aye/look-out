require 'spec_helper'

RSpec.describe LookOut::Client do
  let(:dummy_class) { DummyClass }

  class DummyClass
    include HTTParty
    extend LookOut::Client
  end

  describe '#client' do
    subject { dummy_class.client }

    it 'sets up the client' do
      expect(subject.default_options).to eq(
        base_uri: 'https://api.sea-aye.com/v1',
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
