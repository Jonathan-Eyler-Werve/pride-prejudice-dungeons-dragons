## Make the table

# Open the file

DRAGONS = "dragons.txt"

def build_lookup(words)
  lookup = {}
  word_1 = "/n"
  word_2 = "/n"
  words.each do |nextword| 
    key = keymaker(word_1, word_2)
    if mostly_letters?([word_1, word_2, nextword])
      if lookup[key] == nil
        lookup[key] = [nextword] 
      elsif lookup[key].class == Array 
        lookup[key] << nextword
      else 
        raise "error in building lookup"
      end   
    end  
    word_1 = word_2
    word_2 = nextword  
  end  
  lookup
end 

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

def mostly_letters?(words)
  words.each do |string|
    return false if /\d/ =~ string
    return false if /\\/ =~ string
    return false if /\_\_\_/ =~ string
    return false if /\-\-\-/ =~ string
  end 
  true    
end 

## pick a new words 

## make em into sentences 

## publish that shit 

p build_lookup(parse_table(DRAGONS))

puts
puts "TESTS" 
puts
p File.readable?(DRAGONS)  # file exists
p parse_table(DRAGONS).class == Array # returns an array
p parse_table(DRAGONS).length > 100 # returns some stuff 
p parse_table(DRAGONS).first.class == String # stuff are words

p keymaker("foo","bar") == "foo, bar"
tester = {}
p tester[keymaker("foo", "bar")] == nil 
tester = {"foo, bar" => "baz"}
p tester[keymaker("foo","bar")] == "baz" 

p mostly_letters?([]) == true
p mostly_letters?(["foo","bar","baz"]) == true
p mostly_letters?(["foo","99","baz"]) == false
p mostly_letters?(["foo","bar","baz9"]) == false
p mostly_letters?(["foo","bar","---"]) == false
p mostly_letters?(["foo","bar","___"]) == false

p build_lookup(["foo"]) == {"/n, /n"=>["foo"]}
p build_lookup(["foo9"]) == {}

puts