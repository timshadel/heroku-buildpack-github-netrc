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

Usage
-----

Example usage:

    $ heroku create --stack cedar --buildpack http://github.com/fs-webdev/heroku-buildpack-netrc.git

    # Enable 
    $ heroku labs:enable user-env-compile
    $ heroku config:set GITHUB_AUTH_TOKEN=<my-read-only-token>

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> Github .netrc app detected
           Generated .netrc & .curlrc files (available only at build-time)

TODO!
