# Title:        StanfordMaxEnt<p>
# Description:  A Maximum Entropy Toolkit<p>
# Copyright:    Copyright (c) Kristina Toutanova<p>
# Company:      Stanford University<p>

class MaxentTagger

  # Maintains a map from words to tags and their counts.
  #
  #  @author Kristina Toutanova
  #  @version 1.0
  #
  class Dictionary
    VERBOSE = false

    attr_reader :dict,
                :partTakingVerbs,
                :naWord

    def initialize
      @dict = {} # Map<String,TagCount>
      @partTakingVerbs = {} # Map<Integer,CountWrapper
      @naWord = "NA"
    end

    def setAmbClasses
      raise NotImplementedError
    end

  end
end
