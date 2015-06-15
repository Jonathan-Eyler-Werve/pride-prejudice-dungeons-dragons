## Make the table

# Open the file

DRAGONS = "dragons.txt"


def parse_table(filename)
  table = []
  file = File.open(filename)
  file.each do |line|
    words = line.split(" ")
    words.each do |word|
      table << word
    end  
  end  
  table
end 

def keymaker(thing_1,thing_2)
  thing_1 + ", " + thing_2
end  

def build_lookup(words)
  lookup = {}
  w1 = "/n"
  w2 = "/n"
  words.each do |nextword| 
    key = keymaker(w1,w2)
    if lookup[key] == nil
      lookup[key] = [nextword] 
    elsif lookup[key].class == Array 
      lookup[key] << nextword
    else 
      raise "error in building lookup"
    end   
    w1 = w2
    w2 = nextword  
  end  
  lookup
end 

# parse the file
# Create tuples
# if key exists, << set into array. If not, create it. 
# { "if, you": ["want", "have", "go"] }

## pick a new words 

## make em into sentences 

## publish that shit 

p build_lookup(parse_table(DRAGONS))

## TESTS 

p File.readable?(DRAGONS)  # file exists
p parse_table(DRAGONS).class == Array # returns an array
p parse_table(DRAGONS).length > 100 # returns some stuff 
p parse_table(DRAGONS).first.class == String # stuff are words
p keymaker("foo","bar") == "foo, bar"
tester = {}
p tester[keymaker("foo", "bar")] == nil 
tester = {"foo, bar" => "baz"}
p tester[keymaker("foo","bar")] == "baz" 
