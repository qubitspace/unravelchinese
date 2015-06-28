# ruby encoding: utf-8
require 'pp'
require 'monban'

# Ensure that the pinyin_cs collation is correct since it gets reset when db:setup is run.
connection = ActiveRecord::Base.connection()
connection.execute("ALTER TABLE words MODIFY `pinyin_cs` varchar(255) COLLATE utf8_bin;")

user1 = Monban::Services::SignUp.new({username: 'qubitspace', email: 'sethwilberger@gmail.com', password: 'password', role: :admin}).perform
user2 = Monban::Services::SignUp.new({username: 'seth', email: 'seth@gmail.com', password: 'password'}).perform

google = Source.create name: "Google", link: "https://translate.google.com"
bing = Source.create name: "Bing", link: "http://www.bing.com/translator"
antosch_and_lin = Source.create name: "Antosch & Lin", link: "https://www.antosch-and-lin.com"
yoyo_chinese = Source.create name: "Yoyo Chinese", link: "http://yoyochinese.com"
chinese_reading_practice = Source.create name: "Chinese Reading Practice", link: "http://chinesereadingpractice.com"

batch = []
batch_number = 1
batch_size = 5000
line_count = File.open( "D:\\rails\\unravelchinese\\db\\dictionary.csv", "r:UTF-8" ).count - 1

File.open( "D:\\rails\\unravelchinese\\db\\dictionary.csv", "r:UTF-8" ).each_with_index do |line, i|

  batch << line
  if batch.size == batch_size or i == line_count
    ActiveRecord::Base.transaction do
      batch.each do |batch_line|
        simplified, traditional, pinyin, hsk_char_level, hsk_word_level, char_freq, word_freq, strokes, radical_number, definitions = batch_line.strip.split "\t"

        word = Word.create  simplified: simplified,
                            traditional: traditional,
                            pinyin: pinyin,
                            pinyin_cs: pinyin,
                            hsk_character_level: hsk_char_level,
                            hsk_word_level: hsk_word_level,
                            character_frequency: char_freq,
                            word_frequency: word_freq,
                            strokes: strokes,
                            radical_number: radical_number,
                            category: :word,
                            noun: !!(/[[:upper:]]/.match(pinyin[0]) and not /[[:upper:]]/.match(simplified[0]))

        definitions.split("/").each_with_index do |value, j|
						value =~ /\{\{(.*?)\}\}/
						tags = $1.nil? ? [] : $1.split('|')
						value.sub! /\{\{.*\}\}/, ''
            definition = Definition.create word: word, value: value, rank: j

						tags.each { |tag_name|
							definition.tag tag_name
						}
        end

      end
    end
    batch = []
    puts "Done #{batch_number * batch_size}"
    batch_number += 1
  end

end

"。，！？；：（ ）【 】「」﹁﹂『』、“‘’”‧《》〈〉 ～﹏—….,;:'\"?~`!@\#$%^&*()\\/-+_|[]{}<> \u3000".each_char do |c|
  Word.create  simplified: c, category: :punctuation
end
