# Restool

Make HTTP requests and handle its responses using simple method calls. Restool turns your HTTP API and its responses into Ruby interfaces.

## Installation

Add the following line to Gemfile:

`gem 'restool'`

and run bundle install from your shell.

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
```

If you prefer the raw response (JSON) you should not define the `response` parameter in the operation configuration.

Missing keys in the response but present in the representation will have a `nil` value in the converted response object.

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

## Additional configuration options

### Basic authentication
```
services:
  - name: example_api
    url: http://example.api
    basic_auth:
      username: ...
      password: ...
    ...
```

### Persistent connection

```
services:
  - name: example_api
    url: http://example.api
    persistent_connection:
      pool_size: 10
      warn_timeout: 0.25
      force_retry: false
    ...
```

### Timeout
```
services:
  - name: example_api
    url: http://example.api
    timeout: 20 #seconds
    ...
```

## Multiple services

You can define multiple services, each one in a different file. These files should be placed in a `config/restool/` directory.

For instance, for the Github API we could have used `config/restool/github.json` or `config/restool/github_api.yml` instead of `config/restool.yml`.

## Multipart

This gem currently does not support multipart requests

# Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

# Licence
This software is licensed under the MIT license.

# Inspiration credits

This gem is inspired by two gems developed by [Moove it](http://www.moove-it.com):

- https://github.com/moove-it/angus-sdoc
- https://github.com/moove-it/angus-remote
