module Tmg
  class CLI < Thor
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
  end
end
