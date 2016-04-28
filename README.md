# Kami

Formerly NotablePDF, [Kami](https://www.kamihq.com/) provides Beautiful Document Viewer and Annotation Software.

API Overview: https://www.kamihq.com/api/

API Documentation: http://docs.kamiembeddingapi.apiary.io/


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kami', github: 'jheth/kami'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kami

## Usage

### Create Client

An API Key is required to communicate with Kami. Contact them for details.

```ruby
client = Kami::Client.new('ABC-vRXxiGb7Nty9mXYZ')
```

### List Documents

Return a list of all documents previously uploaded.

```ruby
list = client.documents
# =>
[
  {
    "name": "example.pdf",
    "document_identifier": "797003eeefa82bd465e9b806a592b005",
    "file_status": "done",
    "file_error_message": null,
    "created_at": "2016-04-27T22:32:32.098Z"
  }
]
```

### Upload Document

File uploads can be done from the local file system or via publicly available URLs.

```ruby
client.upload(name: 'sample.pdf', file: '/path/to/file')
# OR
client.upload(name: 'sample.pdf', document_url: 'https://path/to/file')

# =>
{
  "name": "example.pdf",
  "document_identifier": "797003eeefa82bd465e9b806a592b005",
  "file_status": "processing",
  "file_error_message": null,
  "created_at": "2016-04-27T22:32:32.098Z"
}
```

### Delete Document

Delete document by passing the Kami document identifier

```ruby
client.delete_document('797003eeefa82bd465e9b806a592b005')
```

### Retrieve Document

```ruby
client.document('797003eeefa82bd465e9b806a592b005')
# =>
Kami::Document(document_id: '797003eeefa82bd465e9b806a592b005')
```

### Load Document

```ruby
document = Kami::Document.new('797003eeefa82bd465e9b806a592b005')
```

### Document Status

```ruby
document.status
#=>
{
  "name": "example.pdf",
  "document_identifier": "797003eeefa82bd465e9b806a592b005",
  "file_status": "done",
  "file_error_message": null,
  "created_at": "2016-04-27T22:32:32.098Z"
}
```

### Session View URL

Creates an active viewer session and URL to be used in an embedded iframe.

```ruby
document.session_view_url
#=>
"https://embed.kamihq.com/web/viewer.html?source=embed_api..."
```

```ruby
document.session_view
#=>
{
  "view_session_key": "ANgoQRGNgj-YF8rdfoTk",
  "viewer_url": "https://embed.kamihq.com/web/viewer.html?source=embed_api...",
  "session_expiry": "2016-04-28T04:22:09.000Z"
}
```

### Document Comments

Returns list of authors and comments associated with the document.

```ruby
document.comments
#=>
{
  "authors":  [{}, ...],
  "comments": [{}, ...]
}
```

### Create Document Export

A Document is scheduled for export, which creates a unique job ID.

```ruby
document.create_export(type: 'annotation')

#=>
{
  "id": '6cb4de71-c3d5-40c2-8b88-4774ea92db9a',
  "status": 'pending',
  "file_url": null,
  "error_type": null
}
```

### Get a Document Export

```ruby
document.export_file('6cb4de71-c3d5-40c2-8b88-4774ea92db9a')
#=>
{
  "id": "6cb4de71-c3d5-40c2-8b88-4774ea92db9a",
  "status": "done",
  "file_url": "https://s3.amazonaws.com/FILE_URL",
  "error_type": null
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jheth/kami.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
