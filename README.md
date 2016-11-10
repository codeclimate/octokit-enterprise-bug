
The default Github Enterprise installation exposes its API at endpoints
prefixed with `/api/v3`. The current version of Octokit, however, has a bug
where when configuring the `api_endpoint`, as [recommended](https://github.com/octokit/octokit.rb#working-with-github-enterprise), results in requests to an
incorrect url.

##Expected behavior:

Configuring the Octokit client's `api_endpoint` value as

```
client = Octokit::Client.new(
  api_endpoint: "https://somedomain.com/api/v3",
  client_id: "123"
)
```

then calling `client.check_application_authorization("some-token")`

should result in a request to

```
https://somedomain.com/api/v3/applications/abc/tokens/some-token
```

##Actual behavior:

A request is made to 

```
https://somedomain.com/applications/abc/tokens/some-token
```

Notice the omitted `/api/v3`

##Steps to reproduce

run `rspec spec/test.rb` from the root of this repository

##Investigation

The problem can be traced down to where the request url is built in [Faraday](https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb#L406)

On these lines, `base` is a `URI` instance and the `+` operator is defined on `URI` as an alias to `merge` which does not exhibit the same behavior as concatenation and is why the `/api/v3` portion of the path gets lost.

##Proposed resolution

At the moment, I'm not certain how to correct this issue from Octokit's point of view, but am happy to help.
