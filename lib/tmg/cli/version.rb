module Tmg
  class CLI < Thor
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
        gems_versions[gem_name] = Thread.new {
          Thread.current[gem_name] = Gems.latest_version(gem_name)['version']
        }
      end

      puts "\nGems:".upcase.yellow.bold
      gems_versions.each do |gem_name, version|
        version.join
        if version[gem_name] != 'unknown'
          puts '✔ '.green.bold + gem_name.bold + ' → '.green.bold + version[gem_name].green
        else
          puts "✘ #{gem_name} → ".red.bold + version[gem_name].yellow if options[:invalid]
        end
      end
      puts
    end
  end
end
