require 'thing-client/resource'

RSpec.describe ThingClient::Resource do
  let(:session) { double }
  let(:resource) { ThingClient::Resource.new(data, session: session) }

  describe '#[]' do
    context 'empty data' do
      let(:data) { {} }

      it do
        expect(resource[:id]).to be_nil
      end
    end

    context 'some data' do
      let(:data) { { 'id' => 1 } }

      it do
        expect(resource[:id]).to eql(1)
      end
    end
  end

  describe '#link / #links' do
    context 'empty data' do
      let(:data) { {} }

      it do
        expect(resource.links).to eql({})
      end
    end

    context 'a normal link' do
      let(:data) {
        {
          '_links' => {
            'foo' => { 'href' => 'http://example.com' },
          },
        }
      }

      it 'is a Link' do
        expect(resource.links.size).to eql(1)

        link = resource.link(:foo)

        expect(link).to be_instance_of(ThingClient::Link)
        expect(link.session).to be(session)
        expect(link.href).to eql('http://example.com')
      end
    end

    context 'a link collection' do
      let(:data) {
        {
          '_links' => {
            'foo' => [
              { 'href' => 'http://example.com/a' },
              { 'href' => 'http://example.com/b' },
            ],
          },
        }
      }

      it 'is an array of Links' do
        expect(resource.links.size).to eql(1)

        collection = resource.link(:foo)

        expect(collection.size).to eql(2)

        link1 = collection[0]
        link2 = collection[1]

        expect(link1).to be_instance_of(ThingClient::Link)
        expect(link1.session).to be(session)
        expect(link1.href).to eql('http://example.com/a')

        expect(link2).to be_instance_of(ThingClient::Link)
        expect(link2.session).to be(session)
        expect(link2.href).to eql('http://example.com/b')
      end
    end
  end

  describe '#link!' do
    let(:data) {
      {
        '_links' => {
          'foo' => { 'href' => 'http://example.com' },
        },
      }
    }

    context 'when the link exists' do
      it do
        expect(resource.link!(:foo)).to be_instance_of(ThingClient::Link)
      end
    end

    context 'when the link does not exist' do
      it do
        expect {
          resource.link!(:bar)
        }.to raise_error(KeyError)
      end
    end
  end

  describe '#resource / #resources' do
    context 'empty data' do
      let(:data) { {} }

      it do
        expect(resource.resources).to eql({})
      end
    end

    context 'a singular resource' do
      let(:data) {
        {
          '_embedded' => {
            'item' => { 'id' => 1 },
          },
        }
      }

      it 'is a Resource' do
        expect(resource.resources.size).to eql(1)

        subresource = resource.resource(:item)

        expect(subresource).to be_instance_of(ThingClient::Resource)
        expect(subresource[:id]).to eql(1)
        expect(subresource.session).to be(session)
      end
    end

    context 'a collection resource' do
      let(:data) {
        {
          '_embedded' => {
            'items' => [
              { 'id' => 1 },
              { 'id' => 2 },
            ],
          },
        }
      }

      it 'is an array of Resources' do
        expect(resource.resources.size).to eql(1)

        collection = resource.resource(:items)

        expect(collection.size).to eql(2)

        resource1 = collection[0]
        resource2 = collection[1]

        expect(resource1).to be_instance_of(ThingClient::Resource)
        expect(resource1[:id]).to eql(1)
        expect(resource1.session).to be(session)

        expect(resource2).to be_instance_of(ThingClient::Resource)
        expect(resource2[:id]).to eql(2)
        expect(resource2.session).to be(session)
      end
    end
  end

  describe '#resource!' do
    let(:data) {
      {
        '_embedded' => {
          'foo' => { 'id' => 1 },
        },
      }
    }

    context 'when the resource exists' do
      it do
        expect(resource.resource!(:foo)).to be_instance_of(ThingClient::Resource)
      end
    end

    context 'when the resource does not exist' do
      it do
        expect {
          resource.resource!(:bar)
        }.to raise_error(KeyError)
      end
    end
  end
end
