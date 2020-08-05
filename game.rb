class English
  $english = []
  $turkish = []
  $explanation = Hash.new()
  $point = 0
  $file = "words.txt"
  $file2 = "words2.txt"
  $deletedWords = []
  def readFile() 
    puts "File will be read."
    File::open( "/Users/oguzozan/Desktop/ruby/english-game/#{$file}", "r" ) do |f|
      file_data = f.readlines.map(&:chomp)  
      if file_data.respond_to?('each')
          file_data.each do |line|
              new_words = line.split("\t")
              fillDeletedWords()
              unless $deletedWords.include?(new_words[0])
              $english.append(new_words[0])
              $turkish.append(new_words[1])
              if new_words.length == 3
                $explanation["#{new_words[0]}"] = new_words[2]
              end
          end
        end
        end
      end
      puts "File read completed."
    end

  def writeFile(str)
    File::open( "/Users/oguzozan/Desktop/ruby/english-game/#{$file}", "a" ) do |f|
      f << str.downcase
    end
  end

  def writeDeletedFile(str)
    File::open( "/Users/oguzozan/Desktop/ruby/english-game/#{$file2}", "a" ) do |f|
      f << str.downcase
    end
  end

  def fillDeletedWords()
    File::open( "/Users/oguzozan/Desktop/ruby/english-game/#{$file2}", "r" ) do |f|
      file_data = f.readlines.map(&:chomp)
      if file_data.respond_to?('each')
          file_data.each do |line|
          $deletedWords.append(line)
        end
      end
    end
  end



if __FILE__ == $0
program = English.new()
  program.readFile()


$a = 0
loop do
print "1. Yeni kelime ekle\n
2. Karışık oyun oyna\n
3. Yakın zamanda eklediklerinden oyna\n
4. Tüm kelimeleri göster\n
5. Kelime sil\n
6. Kapat\n
Seçiminiz:"

$a = gets.to_i
break if $a == 6

# Writing to the file
if $a == 1
  puts "İngilizce:"
  ing = gets
  puts "Türkçe:"
  tur = gets
  puts "Açıklama (opsiyonel)"
  exp = gets
  unless ing == "" && tur == ""
    if exp == ""
      program.writeFile("#{ing.chomp}\t#{tur.chomp}\n")
    else
      program.writeFile("#{ing.chomp}\t#{tur.chomp}\t#{exp.chomp}\n")
    end
  end  
end

if $a == 2
  len = $english.length
  $i = 0
  $limit = 10
  $point = 0

  print "Kelime limiti girin (default:10):"
  $limit = gets.to_i
  
  while $i < $limit do
    num = rand(len)
    puts "\nSıradaki kelime: '#{$english[num]}'\nCevap için: C. Açıklama için: E"
    $answer = gets.chomp
    if($answer == "e")
      puts "Açıklama: #{$explanation["#{$english[num]}"]}"
      puts "Cevap için: C"
      $answer = gets.chomp
    end
  
    if($answer == "c")
      puts "'#{$turkish[num]}'. Bildiysen Y, bilemediysen N"
      $answer = gets.chomp
      if($answer == "y")
      $point += 1
      end 
    end
    $i += 1
  end
  puts "Skor: #{$point}/#{$limit}"
   File::open( "/Users/oguzozan/Desktop/ruby/english-game/results.txt", "a+" ) do |f|
      f << "Skor: #{$point}/#{$limit}\n"
    end
end

if $a == 4
  $english.each_with_index do |word, index|
    puts "#{index} :  #{$english[index]} -- #{$turkish[index]} -- #{$explanation["#{$english[index]}"]}"
  end
end

if $a == 5
  puts "Silmek istediğiniz kelimeyi girin: "
  $answer = gets.chomp
  found = $english.detect {|e| e == "#{$answer}"}
  found_tr = $turkish[$english.index(found)]
  puts "#{found} and #{found_tr} and #{$explanation[found]}"
  $english.delete(found)
  $turkish.delete(found_tr)
  $explanation.delete($explanation[found])
  $deletedWords.append(found)
  program.writeDeletedFile("#{found}\n")

  
end

if $a == 6
  end


end
end
end




