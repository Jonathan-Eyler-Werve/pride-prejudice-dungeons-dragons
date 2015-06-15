## Make the table

# Open the file

FILENAME = "dragons.txt"

def parse_table(filename, table)
  file = File.open(filename)
  file.each do |line|
    words = line.split(" ")
    words.each do |word|
      table << word
    end  
  end  
  table
end 


# parse the file
# Create tuples
# if key exists, << set into array. If not, create it. 
# { "if, you": ["want", "have", "go"] }

## pick a new words 

## make em into sentences 

## publish that shit 



# TESTS 

p File.readable?(FILENAME)  # file exists
p parse_table(FILENAME, []).class == Array # returns an array
p parse_table(FILENAME, []).length > 100 # returns some stuff 
p parse_table(FILENAME, []).first.class == String # stuff are words
