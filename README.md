# ThingClient

This project is an experimental client for HAL-ish APIs and _should_ work well with the equally experimental [thing-serializer](https://github.com/benpickles/thing-serializer). It has been entirely inspired by [Ismael](https://github.com/ismasan)'s [Bootic API Client](https://github.com/bootic/bootic_client.rb), his [LRUG talk on writing a Ruby API client](https://skillsmatter.com/skillscasts/10029-practical-hypermedia-apis-in-ruby) (and [corresponding blog post](https://robots.thoughtbot.com/writing-a-hypermedia-api-client-in-ruby)), and numerous conversations with him over the years.

## Example

Initialize a [`Session`](./lib/thing-client/session.rb) with your API's root URL and fetch its resource:

```ruby
session = ThingClient.root('http://example.com/api')
root = session.get
```

This receives the following response and returns a [`Resource`](./lib/thing-client/resource.rb).

```
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "_links": {
    "self": {
      "href": "http://example.com/api"
    },
    "lists": {
      "href": "http://example.com/api/lists"
    }
  }
}
```

A link is accessed with `Resource#link` which returns a [`Link`](./lib/thing-client/link.rb) that can be followed, issuing another HTTP request and returning another [`Resource`](./lib/thing-client/resource.rb).

```ruby
root.link(:lists).href
# "http://example.com/api/lists"

lists = root.link(:lists).call
```

```
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "_links": {
    "self": {
      "href": "http://example.com/api/lists"
    }
  },
  "_embedded": {
    "lists": [
      {
        "_links": {
          "self": {
            "href": "http://example.com/api/lists/1"
          }
        },
        "id": 1,
        "name": "Shopping",
        "_embedded": {
          "items": [
            {
              "_links": {
                "self": {
                  "href": "http://example.com/api/lists/1/items/1"
                }
              },
              "id": 1,
              "name": "Eggs",
              "complete": true
            },
            {
              "_links": {
                "self": {
                  "href": "http://example.com/api/lists/1/items/2"
                }
              },
              "id": 2,
              "name": "Ham",
              "complete": true
            },
            {
              "_links": {
                "self": {
                  "href": "http://example.com/api/lists/1/items/3"
                }
              },
              "id": 3,
              "name": "Cheese",
              "complete": false
            }
          ]
        }
      }
    ]
  }
}
```

An embedded resource is accessed with `Resource#resource` and returns a [`Resource`](./lib/thing-client/resource.rb), its properties are read with `Resource#[]`.

```ruby
list = lists.resource(:lists).first

list.resource(:items).map { |item| item[:name] }

# ["Eggs", "Ham", "Cheese"]
```

So the gist of it is that a `Resource` can have many `Resource`s any of which can have many `Link`s - it's [HAL](http://stateless.co/hal_specification.html) - any of which can be traversed.
