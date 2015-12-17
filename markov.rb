## Make the lookup table

DRAGONS = "the-DND-monsters-manual.txt"
PRIDE = "austin--pride-and-prejudice.txt"
PLATO = "plato--the-replublic.txt"
JOB = "bible--book-of-job.txt"
LONDON = "jack-london.txt"
JEEVES = "wodehouse.txt"

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
    if source_counter[source_preference] >= source_counter.min + 3
      #change to least used source if possible
      bestfit_lookup_index = source_counter.index(source_counter.min)
      wildcard_lookup_index = rand(lookups.length - 1)

      if lookups[bestfit_lookup_index][key] != nil
        source_preference = bestfit_lookup_index
        current_lookup = lookups[source_preference]
        puts "changed source to bestfit " + source_preference.to_s
        puts sentence
      elsif lookups[wildcard_lookup_index][key] != nil
        source_preference = wildcard_lookup_index
        current_lookup = lookups[wildcard_lookup_index]
        # puts "changed source to wildcard " + source_preference.to_s
        # puts sentence
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

    if loop_counter >= 100
      # puts "we are over loop counter: " + word_1 + " " + word_2 + " " + next_word
      break
    end
  end

  return sentence[1..-1] if sentence.length > 15 # chuck out the sentence if it's too short
  # puts "sentence was too short"
  make_sentence(lookups)
end

def end_of_sentence?(word)
  return false if ["Mr.", "Ms.", "Mrs.", "Dr."].include?(word)
  return true if SENTENCE_END_CHARS.include?(word[-1])
  false
end

puts "building pride lookup"
pride_lookup = build_lookup(parse_table(PRIDE))
puts "building monsters lookup"
dragons_lookup = build_lookup(parse_table(DRAGONS))
puts "building republic lookup"
plato_lookup = build_lookup(parse_table(PLATO))
puts "building job lookup"
job_lookup = build_lookup(parse_table(JOB))
puts "building jack london lookup"
london_lookup = build_lookup(parse_table(LONDON))
puts "building Jeeves lookup"
jeeves_lookup = build_lookup(parse_table(JEEVES))


# puts
# puts "Dragons and Job"
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# p make_sentence([dragons_lookup, job_lookup])
# puts
# puts "plato and job"
# p make_sentence([plato_lookup, job_lookup])
# p make_sentence([plato_lookup, job_lookup])
# p make_sentence([plato_lookup, job_lookup])
# p make_sentence([plato_lookup, job_lookup])
# p make_sentence([plato_lookup, job_lookup])
# p make_sentence([plato_lookup, job_lookup])
# puts
# puts "Pride and Job"
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# p make_sentence([pride_lookup, job_lookup])
# puts
# puts
# puts "London and all of them"
# 10.times do
#   puts make_sentence([dragons_lookup, london_lookup, pride_lookup, job_lookup, plato_lookup])
#   puts
# end
# puts make_sentence([pride_lookup, london_lookup])
# p make_sentence([pride_lookup, london_lookup])
# p make_sentence([london_lookup, job_lookup])
# p make_sentence([london_lookup, job_lookup])
# p make_sentence([london_lookup, job_lookup])
# p make_sentence([dragons_lookup, london_lookup])

p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([london_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])
p make_sentence([jeeves_lookup, pride_lookup])

# puts



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