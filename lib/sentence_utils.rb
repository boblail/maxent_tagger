require "core_label"

class SentenceUtils

  def self.toWordList(words)
    words.map do |word|
      cl = CoreLabel.new
      cl.setValue(word)
      cl.setWord(word)
      cl
    end
  end

end
