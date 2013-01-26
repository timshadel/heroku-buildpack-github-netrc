require 'json'

def valid_login?
  login != "error"
end

def login
  @login ||= github_user_login
end

def github_user_login
  json = `curl -s https://api.github.com/user` rescue "{}"
  user = JSON.parse json rescue {}
  user["login"] || "error"
end

def github_user_auth token
  json = `curl -s https://api.github.com/authorizations` rescue "[]"
  all = JSON.parse json rescue []
  authz = all.select {|a| a["token"] =~ /#{token}/}.first
  "#{authz["note"]} (#{authz["scopes"].include?('repo') ? 'private repo access' : 'insufficient access'})"
end

def github_user_orgs
  json = `curl -s https://api.github.com/user/orgs` rescue "[]"
  orgs = JSON.parse json rescue []
  orgs.map {|o| o["login"].downcase }.sort
end

def user_block token
  <<-USER
       Github User:   #{login}
       Authorization: #{github_user_auth(token)}
       Organizations: #{github_user_orgs.join(", ")}
  USER
end
