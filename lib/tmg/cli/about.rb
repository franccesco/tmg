module Tmg
  class CLI < Thor
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
