## Make the lookup table

DRAGONS = "dragons.txt"
PRIDE = "pride.txt"

SENTENCE_END_CHARS = [".","!","?",":"]

def build_lookup(words)
  lookup = {}
  word_1 = "\n"
  word_2 = "\n"
  words.each do |nextword| 
    nextword.delete!("\"")
    nextword.delete!("(")
    nextword.delete!(")")
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
    if line == "\n"
      table << "\n"
      table << "\n"
    else  
      words = line.split(" ")
      words.each do |word|
        table << word
      end  
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

def make_sentence(lookups)
  sentence = ""
  word_1 = "\n"
  word_2 = "\n"  
  next_word = "\n" #["It", "The", "If", "They", "We", "What", "Do", "Is", "This", "A", "Giants"].sample
  source_preference = rand(lookups.length-1)
  
  source_counter = []
  lookups.length.times do 
    source_counter << 0
  end  
  
  current_lookup = lookups[source_preference]
  loop_counter = 0
  until end_of_sentence?(next_word)
    loop_counter += 1
    key = keymaker(word_1, word_2)

    #check if we need to change the source
    if source_counter[source_preference] >= source_counter.min + 5
      #change to least used source if possible

      potential_lookup_index = source_counter.index(source_counter.min)
      if lookups[potential_lookup_index][key] != nil
        source_preference = potential_lookup_index 
        current_lookup = lookups[source_preference]
        # puts "changed source to " + source_preference.to_s
      end  
    end  
    
    if current_lookup[key] != nil
      source_counter[source_preference] += 1 
      next_word = current_lookup[key].sample
      sentence = sentence + " " + next_word if next_word != "\n"
    end  
    word_1 = word_2
    word_2 = next_word 
    break if word_1 + word_2 + next_word == "\n\n\n"
    break if loop_counter >= 200 
  end 
  return sentence[1..-1] if sentence.length > 15 # chuck out the sentence if it's too short
  puts "sentence was too short"
  make_sentence(lookups) 
end  

def end_of_sentence?(word)
  return false if ["Mr.", "Ms.", "Mrs.", "Dr."].include?(word)
  return true if SENTENCE_END_CHARS.include?(word[-1]) 
  false
end
## make em into sentences 

p make_sentence([dragons_lookup, dragons_lookup])
p make_sentence([pride_lookup, dragons_lookup])
p make_sentence([pride_lookup, dragons_lookup])
p make_sentence([pride_lookup, dragons_lookup])
p make_sentence([pride_lookup, dragons_lookup])


## publish that shit 

puts
puts "TESTS RUNNING" 
puts
raise "test failed" unless File.readable?(DRAGONS)  # file exists
raise "test failed" unless parse_table(DRAGONS).class == Array # returns an array
raise "test failed" unless parse_table(DRAGONS).length > 100 # returns some stuff 
raise "test failed" unless parse_table(DRAGONS).first.class == String # stuff are words

raise "test failed" unless keymaker("foo","bar") == "foo, bar"
tester = {}
raise "test failed" unless tester[keymaker("foo", "bar")] == nil 
tester = {"foo, bar" => "baz"}
raise "test failed" unless tester[keymaker("foo","bar")] == "baz" 

raise "test failed" unless mostly_letters?([]) == true
raise "test failed" unless mostly_letters?(["foo","bar.","baz"]) == true
raise "test failed" unless mostly_letters?(["foo","99","baz"]) == false
raise "test failed" unless mostly_letters?(["foo","bar","baz9"]) == false
raise "test failed" unless mostly_letters?(["foo","bar","---"]) == false
raise "test failed" unless mostly_letters?(["foo","bar","___"]) == false

raise "test failed" unless build_lookup(["foo"]) == {"\n, \n"=>["foo"]}
raise "test failed" unless build_lookup(["foo", "foo9"]) == {"\n, \n"=>["foo"]} # excludes numbers
raise "test failed" unless build_lookup(["foo","bar","baz", "bar", "foo", "bar", "bip"]) == {"\n, \n"=>["foo"], "\n, foo"=>["bar"], "foo, bar"=>["baz", "bip"], "bar, baz"=>["bar"], "baz, bar"=>["foo"], "bar, foo"=>["bar"]}

puts