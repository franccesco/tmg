require 'tmg'
require 'thor'
require 'gems'
require 'colorize'
require 'ruby-progressbar'

module Tmg
  class CLI < Thor
    default_task :list

    desc 'list', 'Show a list of your published gems.'
    def list
      gems = Gems.gems
      gems.each do |gem|
        gem_name = gem['name']
        downloads = gem['downloads']
        version = gem['version']
        info = gem['info']
        homepage = gem['homepage_uri']

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
      puts 'Write your username and password for ' + 'RubyGems.org'.yellow.bold
      username = ask('Username:'.yellow.bold)
      password = ask('Password:'.yellow.bold, echo: false)
      (puts "Aborted.".red.bold; exit) if password.empty?
      puts '*'.green * username.length

      Tmg.write_credentials(username, password)

      puts '⤷ Done.'.green.bold
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

      unless dependencies['runtime'].empty? and dependencies['runtime'].empty?      
        if options[:dependencies]
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
      else
        puts "\s⤷ No dependencies".yellow.bold
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
