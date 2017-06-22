require 'thing-client/link'

module ThingClient
  class Resource
    EMBEDDED = '_embedded'
    LINKS = '_links'

    attr_reader :data, :session

    def initialize(data, session:)
      @data = data
      @session = session
    end

    def [](name)
      data[name.to_s]
    end

    def link(name)
      links[name.to_s]
    end

    def link!(name)
      links.fetch(name.to_s)
    end

    def links
      @links ||= data.fetch(LINKS, {}).transform_values { |link|
        link.is_a?(Array) ?
          link.map { |item| Link.new(item, session: session) } :
          Link.new(link, session: session)
      }
    end

    def resource(name)
      resources[name.to_s]
    end

    def resource!(name)
      resources.fetch(name.to_s)
    end

    def resources
      @resources ||= data.fetch(EMBEDDED, {}).transform_values { |resource|
        resource.is_a?(Array) ?
          resource.map { |item| self.class.new(item, session: session) } :
          self.class.new(resource, session: session)
      }
    end
  end
end
