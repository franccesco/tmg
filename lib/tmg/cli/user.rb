module Tmg
  class CLI < Thor
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
  end
end
