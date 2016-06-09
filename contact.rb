require 'csv'
require 'pg'
require 'pry'

# imagine a pool of contacts, class methods are methods you would want to call on the whole pool, like find, or search, create and .new
# instance methods are methods you call on that instance or created object of that class. .destroy, .










# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
    
   @@conn = PG.connect({
    host: 'localhost',
    dbname: 'contacts',
    user: 'deepak',
    password: 'deepak'
  })




  def initialize(id, name, email)

    @id = id
    @name = name
    @email= email
    
    
  end



  def to_s
    "#{@id}: #{@name}, #{@email}"
  end


  def save
      @@conn.exec_params("INSERT INTO contacts (name, email) VALUES ($1, $2);", [name, email]) #USE EXEC PARAMS WHEN WRITING VALUES. OTHERWISE JUST EXEC
   end  

                                                                         # array stuff must be set with initialize parameters.

  class << self   #all class methods under here

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      
      
      pg_result = @@conn.exec("SELECT * FROM contacts ORDER BY id;") #this just returns an array of hash's. the questions asks for objects. 
      # pg_result.to_a
      #       [{"id"=>"1", "name"=>"Jane, Doe", "email"=>"janne.doe@example.com"},
      #       {"id"=>"2", "name"=>"Jane, Doe", "email"=>"janne.doe@example.com"} ... ]
      
      results = []
      pg_result.each do |contacthash|
        #contacthash is a hash => {"id"=>"1", "name"=>"Jane, Doe", "email"=>"janne.doe@example.com"}
        results << Contact.new(contacthash["id"].to_i, contacthash["name"], contacthash["email"])
        # results << Contact.new(*contact.values)
      end
      results
    end
  
    def find(iden)
    result = @@conn.exec_params("SELECT * FROM contacts WHERE id = $1::int;", [iden])  #always params when you are inputting things into SQL statement
    # result[0]    #since you get back postgres object which is an array full of hashes, call 0 for the first hash in that array
      

        result = Contact.new(result[0]["id"], result[0]["name"], result[0]["email"]) #converting result into object

        
       

    end   
    
    def create(name, email)   #create is the same as doing .new and .save in Activerecord. always call .save on the an object created
      
      contact = Contact.new(nil, name, email)
      puts contact
      contact.save
    end

    

    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    

    # def find(iden)
    #   all.each do |contact|
    #     if iden.to_i == contact.id.to_i
    #       return contact
    #     end
    #   end
    #     nil
    #   # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
    # end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    # def search(term)
    #   all.each do |contact|
    #     if (term.to_s == contact.name.to_s) || (term.to_s == contact.email.to_s)
    #       return contact
    #     end
    #   end
    #     nil
    #   # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    # end
    def search(searchterm)
      searchoperation = @@conn.exec_params("SELECT * FROM contacts WHERE name LIKE '%#{searchterm}%' or email like '%#{searchterm}%';")
       emptyarray = []   #make empty one to fill up with objects
      # puts searchoperation.count   << counts postgres class object
      searchoperation.each do |result|
        # puts result["name"]
             #put quotes when there is a hash
     
      emptyarray << Contact.new(result["id"], result["name"], result["email"])
                                  # parameters that contact expects
                                  # (id, name, email)

      end
      emptyarray



    end



    def update(id)
    the_contact = Contact.find(id)
    the_contact.name = new_name
    the_contact.email = new_email
    
    the_contact.save 


    end

end
