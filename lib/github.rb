require 'json'

def valid_login? token
  login(token) != "error"
end

def login token
  @login ||= github_user_login(token)
end

def github_user_login token
  json = `curl -H "Authorization: Bearer #{token}" -s https://api.github.com/user` rescue "{}"
  user = JSON.parse json rescue {}
  user["login"] || "error"
end

def github_user_auth token
  # This call must use .netrc user/pass combination
  json = `curl -s https://api.github.com/authorizations` rescue "[]"
  all = JSON.parse json rescue []
  authz = all.select {|a| a["token"] =~ /#{token}/}.first || []
  "#{authz["note"]} (#{authz["scopes"].include?('repo') ? 'private repo access' : 'insufficient access'})"
end

def github_user_orgs
  json = `curl -H "Authorization: Bearer #{token}" -s https://api.github.com/user/orgs` rescue "[]"
  orgs = JSON.parse json rescue []
  orgs.map {|o| o["login"].downcase }.sort
end

def user_block token
  <<-USER
       Github User:   #{login(token)}
       Authorization: #{github_user_auth(token)}
       Organizations: #{github_user_orgs(token).join(", ")}
  USER
end
