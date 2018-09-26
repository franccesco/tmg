require "tmg/version"
require 'yaml'
require 'httparty'

module Tmg
  @auth = {'Authorization': self.api_key}

  def self.write_credentials(username,
                             password,
                             outdir = "#{Dir.home}/.gem",
                             outfile = 'credentials')
    # Write credentials rubygems.org API access key to:
    # /home/username/.gem/credentials
    auth = {username: username, password: password}
    yaml = HTTParty.get('https://rubygems.org/api/v1/api_key.yaml',
                              basic_auth: auth)
    File.open("#{outdir}/#{outfile}", "w") { |file| file.write(yaml) }
  end

  def self.api_key
    credentials = YAML.load_file("#{Dir.home}/.gem/credentials")
    credentials[:rubygems_api_key]
  end

  def self.mygems
    auth = @auth
    gems_list = HTTParty.get('https://rubygems.org/api/v1/gems.json',
                             headers: auth)
  end

  def self.total_downloads()
    total_downloads = Hash.new
    mygems = self.mygems
    mygems.each do |gem|
      gem_name = gem['name']
      gem_downloads = gem['downloads']
      total_downloads[gem_name] = gem_downloads
    end
    total_downloads
  end
end
