require 'thing-client/link'

RSpec.describe ThingClient::Link do
  let(:session) { double }
  let(:link) { ThingClient::Link.new(data, session: session) }

  describe '#href' do
    context 'with no href' do
      let(:data) { {} }

      it do
        expect {
          link.href
        }.to raise_error(KeyError)
      end
    end
  end
end
