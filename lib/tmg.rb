require "tmg/version"
require 'yaml'
require 'httparty'
require 'gems'

module Tmg
  def self.write_credentials(username,
                             password,
                             outdir = "#{Dir.home}/.gem",
                             outfile = 'credentials')
    # Write credentials rubygems.org API access key to:
    # /home/username/.gem/credentials
    auth = { username: username, password: password }
    yaml = HTTParty.get('https://rubygems.org/api/v1/api_key.yaml',
                        basic_auth: auth)
    raise 'Access Denied' if yaml.code == 401

    File.open("#{outdir}/#{outfile}", "w") { |file| file.write(yaml) }
    FileUtils.chmod 0600, "#{outdir}/#{outfile}"
  end
end
