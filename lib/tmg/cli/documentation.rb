module Tmg
  class CLI < Thor
    desc 'documentation', 'Open browser to gem\'s documentation'
    # Open browser and navigates to gem's documentation
    def documentation(gem)
      documentation_uri = Gems.info(gem)['documentation_uri']
      if documentation_uri.nil?
        puts "No documentation page for ".red.bold + gem.yellow.bold
        exit(1)
      else
        puts 'Opening documentation for: '.green.bold + gem
        Launchy.open(documentation_uri)
      end
    end
  end
end
