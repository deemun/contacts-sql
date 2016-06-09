require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class Contactlist

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def start_app
    

    if ARGV.empty?
      puts "Here is a list of available commands:"
      puts "new - Create a new contact"
      puts "list - List all contacts"
      puts "show - Show a contact"
      puts "search - Search contact"     
    end  

    if ARGV[0] == "list"

      puts Contact.all

    end  

    if ARGV[0] == "new"

      puts "Enter your name:"
      name = STDIN.gets.chomp
      puts "Enter your email:"
      email = STDIN.gets.chomp
      puts Contact.create(name,email)

    end

    if ARGV[0] == "show"
        id = ARGV[1].to_i
        puts Contact.find(id)
    end

    if ARGV[0].downcase == "search"
      puts "Please enter name or email address"
      term = STDIN.gets.chomp
      puts Contact.search(term)


    end

    if ARGV[0] == "update"
      id = ARGV[1].to_i
      puts Contact.update(id)
      puts "Whats your name"
      new_name = gets.chomp
      new_email = gets.chomp
      
    end

  end


end
main_app = Contactlist.new
main_app.start_app