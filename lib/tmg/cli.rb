require 'tmg'
require 'thor'
require 'gems'
require 'colorize'
require 'launchy'

# CLI modules
require 'tmg/cli/about'
require 'tmg/cli/list'
require 'tmg/cli/login'
require 'tmg/cli/info'
require 'tmg/cli/user'
require 'tmg/cli/version'
require 'tmg/cli/homepage'
require 'tmg/cli/documentation'
require 'tmg/cli/wiki'

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
  # Red     = Errors || Really important things. Red banner looks cool though.
  class CLI < Thor
    default_task :list
    @@credentials_file = "#{Dir.home}/.gem/credentials"

    no_commands do
      # Non-CLI method to display gem information without duplicating code
      # on the other CLI methods. Exits if no gems or users where found.
      def display_gem_info(mygems = true, deps = false, ugem = nil, user = nil)
        no_gems = 'Your profile as no gems.'.red.bold if mygems
        no_user = 'User '.red.bold + user.yellow.bold + \
                  ' not found.'.red.bold if user
        no_gem  = 'Gem '.red.bold + ugem.yellow.bold + \
                  ' not found.'.red.bold if ugem
        if mygems
          gems = Gems.gems
          (puts no_gems; exit ) if gems.empty?
        elsif user
          gems = Gems.gems(user)
          (puts no_user; exit) if gems.include? 'error'
        else
          gems = [Gems.info(ugem)]
          (puts no_gem; exit) if gems[0].empty?
        end

        gems.each do |gem|
          authors           = gem['authors']
          gem_name          = gem['name']
          downloads         = gem['downloads']
          version           = gem['version']
          info              = gem['info']
          gem_page          = gem['project_uri']
          homepage          = gem['homepage_uri']
          dependencies      = gem['dependencies']
          runtime_deps      = dependencies['runtime']
          development_deps  = dependencies['development']

          puts
          puts gem_name.upcase.yellow.bold
          puts '- Authors: '.green.bold   + authors unless mygems
          puts '- Info: '.green.bold      + info
          puts '- Downloads: '.green.bold + downloads.to_s
          puts '- Version: '.green.bold   + version
          puts '- Gem page: '.green.bold  + gem_page unless mygems
          puts '- Homepage: '.green.bold  + homepage if homepage

          next unless deps

          if runtime_deps.empty? && development_deps.empty?
            puts "⤷ No dependencies".yellow.bold
          else
            puts "⤷ Dependencies".yellow.bold
          end
          unless runtime_deps.empty?
            puts "\s⤷ Runtime dependencies".yellow.bold

            dependencies['runtime'].each do |dep|
              puts "\s\s⤷ #{dep['name']} → ".green.bold + dep['requirements'][3..-1]
            end
          end
          unless development_deps.empty?
            puts "\s⤷ Development dependencies".yellow.bold

            dependencies['development'].each do |dep|
              puts "\s\s⤷ #{dep['name']} → ".green.bold + dep['requirements'][3..-1]
            end
          end
        end
        puts
      end
    end
  end
end
