RSpec.describe ThingClient::Session do
  def response_fixture(name)
    path = File.expand_path("../responses/#{name}", __FILE__)
    File.read(path)
  end

  describe '#call' do
    let(:resource) { session.call(url) }
    let(:root_url) { 'http://example.com/api' }
    let(:session) { ThingClient::Session.new(root_url) }

    context 'root' do
      let(:root) { response_fixture(:root) }
      let(:url) { root_url }

      before do
        stub_request(:get, root_url).and_return(root)
      end

      it do
        resource

        expect(WebMock).to have_requested(:get, root_url)
        expect(resource).to be_instance_of(ThingClient::Resource)
      end
    end
  end
end
