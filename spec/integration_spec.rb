RSpec.describe 'integration' do
  def response_fixture(name)
    path = File.expand_path("../responses/#{name}", __FILE__)
    File.read(path)
  end

  describe 'foo' do
    let(:lists_url) { 'http://example.com/api/lists' }
    let(:resource) { ThingClient.root(root_url) }
    let(:root_url) { 'http://example.com/api' }

    before do
      stub_request(:get, lists_url).and_return(response_fixture(:lists))
      stub_request(:get, root_url).and_return(response_fixture(:root))
    end

    it do
      lists = resource.link!(:lists).call

      list1 = lists.resource!(:lists)[0]
      items = list1.resource!(:items)
      item1 = items[0]

      expect(item1[:complete]).to eql(true)
      expect(item1[:id]).to eql(1)
      expect(item1[:name]).to eql('Eggs')
      expect(item1.link(:self).href).to eql('http://example.com/api/lists/1/items/1')
    end
  end
end
