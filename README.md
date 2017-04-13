Heroku buildpack: GitHub private repo access via ~/.netrc
===================================

This buildpack uses a GitHub OAuth2 token exposed as `GITHUB_AUTH_TOKEN`
to resolve private repository URLs without putting a specific username
or password in the URLs saved in local files (e.g. `package.json`).

See [Easier builds and deployments using Git over HTTPS and
OAuth][github-builds] and [GitHub OAuth — Non-web Application Flow][github-oauth] for more detail. Also, you may want to choose a user with read-only access.

If you use this in conjunction with the `labs:pipeline` feature of Heroku, you may
avoid setting the `GITHUB_AUTH_TOKEN` environment variable on your test & prod apps,
and instead only set it on the app where you push your code & which runs the buildpack. See [inheriting config vars](https://devcenter.heroku.com/articles/github-integration-review-apps#inheriting-config-vars).

[github-builds]: https://github.com/blog/1270-easier-builds-and-deployments-using-git-over-https-and-oauth
[github-oauth]: http://developer.github.com/v3/oauth/#create-a-new-authorization

Requirements
------------

You'll need to make a GitHub authorization token. Here's the `curl` command you can use.

```console
$ curl -u 'my-read-only-user' -d '{"scopes":["repo"],"note":"GITHUB_AUTH_TOKEN for Heroku deplyoments","note_url":"https://github.com/timshadel/heroku-buildpack-github-netrc"}' https://api.github.com/authorizations  # GitHub API call
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
  "note": "GITHUB_AUTH_TOKEN for Heroku deployments.",
  "note_url": "https://github.com/timshadel/heroku-buildpack-github-netrc",
  "id": 123456,
}
```

This token may be revoked at any time by visiting the [Applications area][github-apps]
of your GitHub account. You'll see the `note` linked to the `note_url` and the revoke
button right next to it.

You may also create a new token using the GitHub UI; follow the instructions in the [GitHub OAuth help article][github-oauth-help] and ensure your token has the "`repo`" scope.

[github-apps]: https://github.com/settings/applications
[github-oauth-help]: https://help.github.com/articles/creating-an-oauth-token-for-command-line-use

Usage
-----

First, make sure your app already has a buildpack set:

    $ heroku buildpacks

If this does not output an existing buildpack, follow the instructions at https://devcenter.heroku.com/articles/buildpacks

Next, prepend this buildpack to your list of buildpacks, so it runs before your app is built:

    $ heroku buildpacks:add -i 1 https://github.com/timshadel/heroku-buildpack-github-netrc.git

Set your GitHub auth token:

    $ heroku config:set GITHUB_AUTH_TOKEN=<my-read-only-token>

Deploy your app:

```console
$ git push heroku master  # push your changes to Heroku

...git output...

-----> Fetching custom git buildpack... done
-----> Multipack app detected
=====> Downloading Buildpack: https://github.com/timshadel/heroku-buildpack-github-netrc.git
=====> Detected Framework: github-netrc
       Generated .netrc & .curlrc files (available only at build-time)
       GitHub User:   my-read-only-user
       Authorization: GITHUB_AUTH_TOKEN for Heroku deplyoments (private repo access)
       Organizations: my-org, another-org
...
```
