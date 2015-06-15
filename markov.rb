## Make the lookup table

DRAGONS = "dragons.txt"
PRIDE = "pride.txt"

def build_lookup(words)
  lookup = {}
  word_1 = "/n"
  word_2 = "/n"
  words.each do |nextword| 
    nextword.delete!("\"")
    nextword.delete!("\'")
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

pride_lookup = build_lookup(parse_table(PRIDE))
dragons_lookup = build_lookup(parse_table(DRAGONS))

## pick a new words 

## make em into sentences 

## publish that shit 

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
p mostly_letters?(["foo","bar.","baz"]) == true
p mostly_letters?(["foo","99","baz"]) == false
p mostly_letters?(["foo","bar","baz9"]) == false
p mostly_letters?(["foo","bar","---"]) == false
p mostly_letters?(["foo","bar","___"]) == false

p build_lookup(["foo"]) == {"/n, /n"=>["foo"]}
p build_lookup(["foo", "foo9"]) == {"/n, /n"=>["foo"]} # excludes numbers
p build_lookup(["foo","bar","baz", "bar", "foo", "bar", "bip"]) == {"/n, /n"=>["foo"], "/n, foo"=>["bar"], "foo, bar"=>["baz", "bip"], "bar, baz"=>["bar"], "baz, bar"=>["foo"], "bar, foo"=>["bar"]}

puts