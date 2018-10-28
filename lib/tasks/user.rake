namespace :user do
  def ask_for(attribute)
    password = attribute =~ /password/
    value = `read -p #{(attribute.to_s.humanize + ':' + (password ? '' : ' ')).to_json} #{'-s' if password} v && echo $v && v=`.strip
    puts '' if password
    value
  end

  task create: :environment do
    user = nil

    until user&.save
      if user
        puts "\nCouldn't create user:"
        user.errors.full_messages.each { |message| puts "- #{message}" }
        puts ''
      end

      user = User.new([
        :first_name,
        :last_name,
        :phone,
        :email,
        :password,
        :password_confirmation
      ].map{ |attribute| [attribute, ask_for(attribute)] }.to_h)
    end

    puts 'User created'
  end
end
