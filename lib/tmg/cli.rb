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
          puts '—'.yellow.bold * gem_name.length
          puts '⤷ Authors: '.green.bold   + authors unless mygems
          puts '⤷ Info: '.green.bold      + info
          puts '⤷ Downloads: '.green.bold + downloads.to_s
          puts '⤷ Version: '.green.bold   + version
          puts '⤷ Gem page: '.green.bold  + gem_page unless mygems
          puts '⤷ Homepage: '.green.bold  + homepage if homepage

          next unless deps

          if runtime_deps.empty? && development_deps.empty?
            puts "⤷ No dependencies".yellow.bold
          else
            puts "⤷ Dependencies".yellow.bold
          end
          unless runtime_deps.empty?
            puts "\s⤷ Runtime dependencies".yellow.bold

            dependencies['runtime'].each do |dep|
              puts "\s\s⤷ #{dep['name']} ".green.bold + dep['requirements']
            end
          end
          unless development_deps.empty?
            puts "\s⤷ Development dependencies".yellow.bold

            dependencies['development'].each do |dep|
              puts "\s\s⤷ #{dep['name']} ".green.bold + dep['requirements']
            end
          end
        end
        puts
      end
    end

    desc 'list', 'Show a list of your published gems.'
    method_option :dependencies,
                  aliases: '-d',
                  type: :boolean,
                  desc: 'Show dependencies.'
    # Shows a list of your gems published on RubyGems.org
    # If forces you to login first if it's unable to find the credentials
    # under your home folder. After that, it retrieves a summary consisting
    # in the most relevant information only such as info, downloads, version,
    # and homepage.
    def list
      unless File.file?(@@credentials_file)
        login
      end
      display_gem_info(true, options[:dependencies])
    end

    desc 'login', 'Request access to RubyGems.org'
    # Retrieves the API key for the user and writes it to ~/.gem/credentials.
    # It also makes sure to set the permissions to 0600 as adviced on the
    # RubyGems.org webpage. If the credentials file is on the system,
    # then it should warn the user before overwriting the file.
    def login
      # check if file credential exists
      if File.file?(@@credentials_file)
        puts 'Credentials file found!'.bold
        unless yes?("Overwrite #{@@credentials_file}? |no|".bold.yellow)
          puts "Aborted.".red.bold
          exit
        end
      end

      # Ask for username and password, mask the password and make it
      # green if it's the correct password, red if the access was denied.
      # Aborts if the password is empty.
      puts 'Write your username and password for ' + 'RubyGems.org'.yellow.bold
      username = ask('Username:'.yellow.bold)
      password = ask('Password:'.yellow.bold, echo: false)
      (puts "Aborted.".red.bold; exit) if password.empty?

      # fakes a masked password as long as the username,
      # for style purposes only.
      masked_password = '*' * username.length
      print masked_password unless options[:show_password]

      begin
        Tmg.write_credentials(username, password)
      rescue RuntimeError
        puts "\b" * masked_password.length + masked_password.red.bold
        puts 'Access Denied.'.red.bold
        exit
      else
        puts "\b" * masked_password.length + masked_password.green.bold
        puts "Credentials written to #{@@credentials_file}".green.bold
      end
    end

    desc 'info [GEM]', 'Shows information about a specific gem.'
    method_option :dependencies,
                  aliases: '-d',
                  type: :boolean,
                  desc: 'Show dependencies.'
    # Displays information about a gem, optionally displaying
    # runtime dependencies and development dependencies.
    def info(gem)
      display_gem_info(false, options[:dependencies], gem)
    end

    desc 'user [USERNAME]', 'Shows gems owned by another username'
    method_option :dependencies,
                  aliases: '-d',
                  type: :boolean,
                  desc: 'Show dependencies.'
    # Displays the gems that belongs to another user, optionally flag
    # the dependencies (runtime and development)
    def user(username)
      display_gem_info(false, options[:dependencies], nil, username)
    end

    desc 'version [gems]', 'Displays latest version of gems.'
    method_option 'invalid',
                  aliases: '-i',
                  type: :boolean,
                  desc: 'Show invalid gems.'
    # Displays the latest versions of gems
    def version(*gems)
      (puts 'No gems provided'.red.bold; exit ) if gems.empty?
      gems_versions = {}
      gems.each do |gem_name|
        version = Gems.latest_version(gem_name)['version']
        unless options[:invalid]
          next if version == 'unknown'
        end
        gems_versions[gem_name] = version
      end

      header = 'Gem version'
      puts
      puts header.upcase.yellow.bold
      puts '—'.yellow.bold * header.length
      gems_versions.each do |gem_name, version|
        if version != 'unknown'
          puts '⤷ '.green.bold + gem_name.bold + ' → '.green.bold + version.green
        else
          puts "⤷ #{gem_name} → ".red.bold + version.yellow
        end
      end
      puts
    end

    desc 'about', 'Displays version number and information.'
    # Displays information about the installed TMG gem such as:
    # version, author, developer twitter profile and blog, and a banner.
    def about
      puts Tmg::BANNER.bold.red
      puts 'version: '.bold     + Tmg::VERSION.green
      puts 'author: '.bold      + 'Franccesco Orozco'.green
      puts 'Twitter: '.bold     + '@__franccesco'.green
      puts 'homepage: '.bold    + 'https://github.com/franccesco/tmg'.green
      puts 'learn more: '.bold  + 'https://codingdose.info'.green
      puts # extra line, somehow I like them.
    end
  end
end
