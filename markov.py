import random
import sys
import time
import PIL
import textwrap
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw
from twython import Twython
import ConfigParser

config = ConfigParser.ConfigParser()
config.read("config.cfg")
config.sections()
APP_KEY = config.get("twitter", "app_key")
APP_SECRET = config.get("twitter", "app_secret")
OAUTH_TOKEN = config.get("twitter", "oauth_token")
OAUTH_TOKEN_SECRET = config.get("twitter", "oauth_token_secret")

stopword = "\n" # Since we split on whitespace, this can never be a word
stopsentence = (".", "!", "?",) # Cause a "new sentence" if found at the end of a word
sentencesep  = "\n" #String used to separate sentences

# GENERATE TABLE
w1 = stopword
w2 = stopword
table_a = {}
table_b = {}
counter = 0
sourcecounter = 0

twitter = Twython(APP_KEY, APP_SECRET, OAUTH_TOKEN, OAUTH_TOKEN_SECRET)

def load_table(filename, tablename):
    global w1, w2
    w1 = stopword
    w2 = stopword    
    with open(filename) as f:
        for line in f:
            for word in line.split():
                if word[-1] in stopsentence:
                    tablename.setdefault( (w1, w2), [] ).append(word[0:-1])
                    w1, w2 = w2, word[0:-1]
                    word = word[-1]
                tablename.setdefault( (w1, w2), [] ).append(word)
                w1, w2 = w2, word
        tablename.setdefault( (w1, w2), [] ).append(stopword)

 

MAXSENTENCES = 5

def generate_sentences():
    global w1, w2, table_a, table_b, stopword, sourcecounter
    margin = offset = 10
    font = ImageFont.truetype("Lora-Regular.ttf", 16)
    sentence = []
    sentences = []
    tables = [table_a, table_b]
    current_table = random.randint(0, 1)
    source_preference = " "

    while len(sentences) < MAXSENTENCES:

        current_table_a = random.choice([True, False])

        if current_table_a: 
            current_table = 0
            other_table = 1
        else: 
            current_table = 0
            other_table = 1

        if (w1, w2) in tables[other_table].keys(): # can we switch to other source? 
            if sourcecounter <= -2: 
                source_preference = "B"
                # print "prefer source B"
            if sourcecounter >= 2: 
                source_preference = "A"
                # print "prefer source A"

        if source_preference == "A" and (w1, w2) in tables[0].keys(): current_table_a = True
        if source_preference == "B" and (w1, w2) in tables[1].keys(): current_table_a = False

        if current_table_a: #obvious DRY refactor here
            current_table = 0
            other_table = 1
            sourcecounter -= 1
        else: 
            current_table = 1
            other_table = 0 
            sourcecounter += 1  

        if (w1, w2) in tables[current_table].keys():
            newword = random.choice(tables[current_table][(w1, w2)])

            if newword == stopword: sys.exit()
            if newword in stopsentence:
                sentences.append(" ".join(sentence) + newword)
                sentence = []
            else:
                sentence.append(newword)
                w1, w2 = w2, newword   
        else: current_table_a = not current_table_a        

    # print "tweeting..."
    status = max(sentences, key=len)
    try:
        if len(status) > 100:
            # create the image to tweet with
            img = Image.new("RGBA", (400,400),(255,255,255))
            draw = ImageDraw.Draw(img)
            for line in textwrap.wrap(status, width=50):
                draw.text((margin, offset), line, (0,0,0), font=font)
                offset += font.getsize(line)[1]
            draw = ImageDraw.Draw(img)
            img.save('temp.png')
            media = open('temp.png', 'rb')

            status = (status[:100] + '...')
            # twitter.update_status_with_media(media=media, status=status)
            # if (" ").join(sentences).find("Darcy") != -1 or status.find("Elizabeth") != -1: print sentences
            print sentences
        else:
            # twitter.update_status(status=status)
            print status

    except Exception as e:
        print "some sort of error... don't really care...", str(e)

load_table("dragons.txt", table_a)
w1 = stopword
w2 = stopword
load_table("pride.txt", table_b)

while counter < 50:
    # time.sleep(0)
    w1 = stopword
    w2 = stopword
    generate_sentences()
    sourcecounter = 0
    counter = counter + 1
    print "..."
