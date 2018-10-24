module Tmg
  class CLI < Thor
    desc 'wiki', 'Open browser to gem\'s wiki'
    # Open browser and navigates to gem's wiki
    def wiki(gem)
      wiki_uri = Gems.info(gem)['wiki_uri']
      if wiki_uri.nil? || wiki_uri.empty?
        puts "No wiki page for ".red.bold + gem.yellow.bold
        exit(1)
      else
        puts 'Opening wiki for: '.green.bold + gem
        Launchy.open(wiki_uri)
      end
    end
  end
end
