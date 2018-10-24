module Tmg
  class CLI < Thor
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
  end
end
