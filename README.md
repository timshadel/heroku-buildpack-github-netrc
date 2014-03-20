Heroku buildpack: Github private repo access via ~/.netrc
===================================

This buildpack uses a Github OAuth2 token exposed as `GITHUB_AUTH_TOKEN`
to resolve private repository URLs without putting a specific username
or password in the URLs saved in local files (e.g. `package.json`).

See [Easier builds and deployments using Git over HTTPS and
OAuth][github-builds] and [Github OAuth — Non-web Application Flow][github-oauth] for more detail. Also, you may want to choose a user with read-only access.

If you use this in conjunction with the `labs:pipeline` feature of Heroku, you may
avoid setting the `GITHUB_AUTH_TOKEN` environment variable on your test & prod apps,
and instead only set it on the app where you push your code & which runs the buildpack.

[github-builds]: https://github.com/blog/1270-easier-builds-and-deployments-using-git-over-https-and-oauth
[github-oauth]: http://developer.github.com/v3/oauth/#create-a-new-authorization

Requirements
------------

You'll need to make a Github authorization token. Here's the `curl` command you can use.

```console
$ curl -u 'my-read-only-user' -d '{"scopes":["repo"],"note":"GITHUB_AUTH_TOKEN for Heroku deplyoments","note_url":"https://github.com/timshadel/heroku-buildpack-github-netrc"}' https://api.github.com/authorizations  # Github API call
Enter host password for user 'username':  [type password]

{
  "scopes": [
    "repo"
  ],
  "token": "your_token",
  "app": {
    "url": "http://developer.github.com/v3/oauth/#oauth-authorizations-api",
    "name": "Help example (API)"
  },
  "url": "https://api.github.com/authorizations/123456",
  "note": "GITHUB_AUTH_TOKEN for Heroku deplyoments.",
  "note_url": "https://github.com/timshadel/heroku-buildpack-github-netrc",
  "id": 123456,
}
```

This token may be revoked at any time by visiting the [Applications area][github-apps]
of your Github account. You'll see the `note` linked to the `note_url` and the revoke
button right next to it.

Check out the [Github help article][github-oauth-help] and [OAuth documentation][github-oauth] for more details.

[github-apps]: https://github.com/settings/applications
[github-oauth-help]: https://help.github.com/articles/creating-an-oauth-token-for-command-line-use

Usage
-----

Example usage:

    $ heroku create --stack cedar --buildpack https://github.com/fs-webdev/heroku-buildpack-netrc.git

Set the token.

    $ heroku config:set GITHUB_AUTH_TOKEN=<my-read-only-token>

Deploy your app.

```console
$ git push heroku master  # push your changes to Heroku

...git output...

-----> Fetching custom git buildpack... done
-----> Multipack app detected
=====> Downloading Buildpack: https://github.com/timshadel/heroku-buildpack-github-netrc.git
=====> Detected Framework: github-netrc
       Generated .netrc & .curlrc files (available only at build-time)
       Github User:   my-read-only-user
       Authorization: GITHUB_AUTH_TOKEN for Heroku deplyoments (private repo access)
       Organizations: my-org, another-org
```
