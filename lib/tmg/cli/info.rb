module Tmg
  class CLI < Thor
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
  end
end
