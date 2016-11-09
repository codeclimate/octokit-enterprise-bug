require "spec_helper"
require "octokit"

describe "making requests to a Github Enterprise API" do
  describe "Octokit::Client#check_application_authorization" do
    it "makes a request to the correct endpoint" do
      # stub the correct endpoing to illustrate the expected behavior
      # notice the `/api/v3` portion of the path
      stub_request(:get, "https://gh-enterprise.com/api/v3/applications/abc/tokens/some-cool-token").
        to_return(:status => 200, :body => "", :headers => {})

      # stub the incorrect endpoint to demonstrate the bug
      # notice the `/api/v3` portion of the path is missing
      stub_request(:get, "https://gh-enterprise.com/applications/abc/tokens/some-cool-token").
        to_return(:status => 200, :body => "", :headers => {})

      # configure the client with the `/api/v3` path
      client = Octokit::Client.new(
        api_endpoint: "https://gh-enterprise.com/api/v3",
        client_id: "abc",
        client_secret: "123",
      )

      client.check_application_authorization("some-cool-token")

      # Here's the bug:
      # This request is missing the `/api/v3` portion of its path and
      # should not be called.
      # This test will fail.
      expect(WebMock).to_not have_requested(
        :get,
        "https://gh-enterprise.com/applications/abc/tokens/some-cool-token"
      )

      # This is the endpoint expected to be called.
      expect(WebMock).to have_requested(
        :get,
        "https://gh-enterprise.com/api/v3/applications/abc/tokens/some-cool-token"
      )
    end
  end
end
