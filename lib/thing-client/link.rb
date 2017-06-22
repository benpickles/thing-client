module ThingClient
  class Link
    HREF = 'href'

    attr_reader :data, :session

    def initialize(data, session:)
      @data = data
      @session = session
    end

    def call
      session.call(href)
    end

    def href
      data.fetch(HREF)
    end
  end
end
