require 'tmg'
require 'thor'
require 'gems'
require 'colorize'

trap('INT') { puts "\nAborted".red.bold; exit }

module Tmg
  # Commands:
  # tmg about           # Displays version number and information.
  # tmg help [COMMAND]  # Describe available commands or one specific command
  # tmg info [GEM]      # Shows information about a specific gem.
  # tmg list            # Show a list of your published gems.
  # tmg login           # Request access to RubyGems.org
  ##
  # Colorize:
  # Yellow  = Warnings || Things that needs your attention
  # Green   = Notice || Messages of interest
  # White   = Regular strings
  # Red     = Errors || Really important things. I also like the red banner.
  class CLI < Thor
    default_task :list
    @@credentials_file = "#{Dir.home}/.gem/credentials"

    desc 'list', 'Show a list of your published gems.'
    # Shows a list of your gems published on RubyGems.org
    # If forces you to login first if it's unable to find the credentials
    # under your home folder. After that, it retrieves a summary consisting
    # in the most relevant information only such as info, downloads, version,
    # and homepage.
    def list
      unless File.file?(@@credentials_file)
        login
      end
      gems = Gems.gems
      gems.each do |gem|
        gem_name = gem['name']
        downloads = gem['downloads']
        version = gem['version']
        info = gem['info']
        homepage = gem['homepage_uri']

        puts
        puts gem_name.upcase.yellow.bold
        puts '—'.yellow.bold * gem_name.length
        puts '⤷ Info: '.green.bold      + info
        puts '⤷ Downloads: '.green.bold + downloads.to_s
        puts '⤷ Version: '.green.bold   + version
        puts '⤷ Homepage: '.green.bold  + homepage
        puts
      end
    end

    desc 'login', 'Request access to RubyGems.org'
    def login
      if File.file?(@@credentials_file)
        puts 'Credentials file found!'.bold
        unless yes?("Overwrite #{@@credentials_file}? |no|".bold.yellow)
          puts "Aborted.".red.bold
          exit
        end
      end

      puts 'Write your username and password for ' + 'RubyGems.org'.yellow.bold
      username = ask('Username:'.yellow.bold)
      password = ask('Password:'.yellow.bold, echo: false)
      (puts "Aborted.".red.bold; exit) if password.empty?
      puts '*'.green * username.length

      begin
        Tmg.write_credentials(username, password)
      rescue RuntimeError
        puts 'Access Denied.'.red.bold
        exit
      else
        puts "Credentials written to #{@@credentials_file}".green.bold
      end
    end

    desc 'info [GEM]', 'Shows information about a specific gem.'
    method_option :dependencies,
                  aliases: '-d',
                  type: :boolean,
                  desc: 'Show dependencies.'
    def info(gem)
      gem = Gems.info(gem)
      authors = gem['authors']
      gem_name = gem['name']
      info = gem['info']
      downloads = gem['downloads']
      version = gem['version']
      gem_page = gem['project_uri']
      homepage = gem['homepage_uri']
      dependencies = gem['dependencies']

      puts
      puts gem_name.upcase.yellow.bold
      puts '—'.yellow.bold * gem_name.length
      puts '⤷ Authors: '.green.bold             + authors
      puts '⤷ Info: '.green.bold                + info
      puts '⤷ Downloads: '.green.bold           + downloads.to_s
      puts '⤷ Version: '.green.bold             + version
      puts '⤷ Gem page: '.green.bold            + gem_page
      puts '⤷ Homepage: '.green.bold            + homepage

      if dependencies['runtime'].empty? && dependencies['runtime'].empty?
        puts "\s⤷ No dependencies".yellow.bold if options[:dependencies]
      elsif options[:dependencies]
        puts "⤷ Dependencies".yellow.bold
        unless dependencies['runtime'].empty?
          puts "\s⤷ Runtime dependencies".yellow.bold
          dependencies['runtime'].each do |dep|
            puts "\s\s⤷ #{dep['name']} ".green.bold + dep['requirements']
          end
        end
        unless dependencies['development'].empty?
          puts "\s⤷ Development dependencies".yellow.bold
          dependencies['development'].each do |dep|
            puts "\s\s⤷ #{dep['name']} ".green.bold + dep['requirements']
          end
        end
      end
      puts
    end

    desc 'about', 'Displays version number and information.'
    def about
      puts Tmg::BANNER.bold.red
      puts 'version: '.bold + Tmg::VERSION.green
      puts 'author: '.bold + 'Franccesco Orozco'.green
      puts 'Twitter: '.bold + '@__franccesco'.green
      puts 'homepage: '.bold + 'https://github.com/franccesco/tmg'.green
      puts 'learn more: '.bold + 'https://codingdose.info'.green
      puts # extra line, somehow I like them.
    end
  end
end
