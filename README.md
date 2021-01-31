# Restool

Make HTTP requests and handle their responses using simple method calls. Restool turns your HTTP API and its responses into Ruby interfaces.

Use a declarative approach to call any API and decouple from their responses using a custom transformation.

[![Gem Version](https://badge.fury.io/rb/restool.png)](http://badge.fury.io/rb/restool)
[![CircleCI build status](https://circleci.com/gh/jzeni/restool.svg?style=shield)](https://circleci.com/gh/jzeni/restool/tree/master)
[![Travis Build Status](https://travis-ci.org/jzeni/restool.svg?branch=master)](https://travis-ci.org/jzeni/restool)
[![Code Climate](https://codeclimate.com/github/jzeni/restool.svg)](https://codeclimate.com/github/jzeni/restool)
[![Join the chat at https://gitter.im/restool/community](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/restool/community)

## Installation

Add the following line to Gemfile: `gem 'restool', '~> 1'` and run bundle install from your shell.

To install the gem manually from your shell, run: `gem install restool`

## Usage
Define the API endpoint and the response in a YML or JSON file:
```
# config/restool.yml

services:
  - name: github_api
    url: https://api.github.com
    operations:
      - name: get_repos
        path: /users/:username/repos
        method: get
        response:
          - key: id
            metonym: identifier
            type: integer
          - key: full_name
            type: string
          - key: owner
            type: owner

    representations:
      owner:
        - key: login
          metonym: username  # optional
          type: string
        - key: url
          type: string
```

Create the service object passing a response handler block, which will be automatically executed for each response:
```
require 'restool'

remote_service = Restool.create('github_api') do |response, code|
                  raise MyServiceError.new(response) unless code.to_i == 200

                  JSON(response)
                 end
```

Use the `remote_service` object to make calls:
```
uri_params   = [:jzeni]
params       = { sort: :created, direction: :desc }

repositories = remote_service.get_repos(uri_params, params)
```
And that's it!

The response object will define a method for each attribute of the response, with the same name or with the `metonym` name if given:

```
first_repository = repositories.first

id               = first_repository.id
full_name        = first_repository.full_name
owner_username   = first_repository.owner.username
owner_url        = first_repository.owner.url

raw_response     = first_repository._raw   # full raw response
```

If you prefer to work with the raw responses (JSON) you should not define the `response` parameter in the operation configuration.

Some important aspects:
- Missing keys in the response but present in the representation will have a `nil` value in the converted response object.
- The method `._raw` returns the response as it was returned by the response block, including attributes that might not be in the response representation.
- If the response is an array you cannot call `._raw` directly, instead call `._raw` for each element.

### Element types

The available types are:
- string
- integer
- decimal
- boolean

Restool will parse the values to the given type for you.

## More examples

```
# request with uri params, body params and header params
remote_service.example_operation([uri_param_1, uri_param_2, ..., uri_param_n],
                                 { param_name: value },
                                 { header_name: :value })

# request with body params and header params
remote_service.example_operation({ param_name: value }, { header_name: :value })

# request with header params and without body params
remote_service.example_operation({}, { header_name: :value })

# request only with body params
remote_service.example_operation({ param_name: value })
```
See other real examples in the examples directory

## Additional features

### Basic authentication
```
services:
  - name: example_api
    url: http://example.api
    basic_auth:
      user: ...
      password: ...
    ...
```

or pass the credentials when creating the service:
```
opts = { basic_auth: { user: 'my_user', password: ENV['GITHUB_API_PASSWORD'] } }

remote_service = Restool.create('github_api', opts) do |response, code|
```

### Logging
```
require "logger"

my_logger = Logger.new(STDOUT)  # or Logger.new("/path/to/my.log")

remote_service = Restool.create('github_api', logger: my_logger) do |response, code|
                   ...
                 end
```

### Debugging
```
remote_service = Restool.create('github_api', debug: true) do |response, code|
                   ...
                 end
```

### Timeout
```
services:
  - name: example_api
    url: http://example.api
    timeout: 20 #seconds
    ...
```

### Read config

```
configuration = Restool::Settings::Loader.load('github_api')

service_name = configuration.service.name
```


## Multiple services

You can define multiple services, each one in a different file. These files should be placed in a `config/restool/` directory.

For instance, for the Github API we could have used `config/restool/github.json` or `config/restool/github_api.yml` instead of `config/restool.yml`.

## Multipart

This gem currently does not support multipart requests

# Questions?

If you have any question or doubt regarding Restool you can:
- create an issue
- [open a question on Stackoverflow](http://stackoverflow.com/questions/ask?tags=restool) with tag
[restool](http://stackoverflow.com/questions/tagged/restool)
- or [join the chat on Gitter](https://gitter.im/restool/community)

# Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Changelog

### 1.0.4

* Allow to read configuration

### 1.0.3

* Fix error logging when log is enabled

### 1.0.1

* Fixed missing OpenSSL.
* Fixed wrong require.

# Licence
This software is licensed under the MIT license.

# Inspiration credits

This gem is inspired by two gems developed by [Moove it](http://www.moove-it.com):

- https://github.com/moove-it/angus-sdoc
- https://github.com/moove-it/angus-remote
