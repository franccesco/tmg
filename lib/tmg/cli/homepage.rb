module Tmg
  class CLI < Thor
    desc 'homepage', 'Open browser to gem\'s homepage'
    # Open browser and navigates to gem's homepage
    def homepage(gem)
      homepage_uri = Gems.info(gem)['homepage_uri']
      if homepage_uri.nil?
        puts "No homepage for ".red.bold + gem.yellow.bold
        exit(1)
      else
        puts 'Opening homepage of: '.green.bold + gem
        Launchy.open(homepage_uri)
      end
    end
  end
end
