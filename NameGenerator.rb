#!/usr/bin/env ruby
#Simon Moffatt Jan 2013
#Creates an output file of randomized first and last names.  Mix of female and male names.
#Shuffled from dictionaries of 3950 firstnames and 150 lastnames.  Max combinations before bawk of 592500.
#Used in combination with HRGenerator, AccessGenerator and EventGenerator.  May one day combine them.
#http://www.github.com/smof/NameGenerator
 
#requires
require 'rubygems'
require 'csv'

#globals ############################################################################################
FIRSTNAMES_DICTIONARY = "lib/dictionaries/firstnames.dic"
LASTNAMES_DICTIONARY = "lib/dictionaries/surnames.dic"
OUTPUT_FILE = "names.dat"
NUMBER_TO_CREATE = 10000
@firstnames = [] # where firstnames data file gets slurped
@lastnames = [] # where lastnames data file gets slurped
@names = [] # where new names gets stored
#globals ############################################################################################

#slurp in file into array
def read_firstnames
  
  if File.exist? FIRSTNAMES_DICTIONARY
    
    #slurp in all first names into an array
    CSV.foreach FIRSTNAMES_DICTIONARY do |firstname|
    
           @firstnames << firstname[0]
                                
    end
    
  else
    
    puts "Oops!  #{FIRSTNAMES_DICTIONARY} not found"
    exit
    
  end
      
end

#slurp in file into array
def read_lastnames
  
  if File.exist? LASTNAMES_DICTIONARY 
  
    CSV.foreach(LASTNAMES_DICTIONARY) do |lastname|
    
           @lastnames << lastname[0]
                                
    end
  
  else
  
    puts "Oops!  #{LASTNAMES_DICTIONARY} not found"
    exit
    
  end  
    
end


#returns one firstname
def get_firstname
  
  @firstnames[Kernel.rand(@firstnames.length-1)]
    
end

#returns one lastname
def get_lastname
  
  @lastnames[Kernel.rand(@lastnames.length-1)]
  
end



def generate_names 
  
  puts "Generating names...\n"
  processed_record ="."
  new_name = "#{get_firstname} #{get_lastname}"
  
  1.upto NUMBER_TO_CREATE do
    
    while @names.include? new_name
      new_name = "#{get_firstname} #{get_lastname}"
    end
        
    @names << new_name
    STDERR.print processed_record
    
  end
  
  
end



#writes out new names
def write_names
  
  puts "\nWriting out new name file...\n"
  processed_record ="."
  output_file = File.open(OUTPUT_FILE, 'w')
  
  @names.each do |user| 
    output_file.puts user.to_s 
    STDERR.print processed_record
  end #basic puts but driven to open file
  
  output_file.close #closes
  puts "\nCompleted writing out new names \n#{@names.length} records processed"
  puts "Started #{@started}"
  puts "Ended #{Time.now}"

end


#run through
@started = Time.now
read_firstnames
read_lastnames
generate_names
write_names

