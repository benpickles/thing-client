require 'thing-client/session'
require 'thing-client/version'

module ThingClient
  def self.root(url)
    Session.root(url)
  end
end
