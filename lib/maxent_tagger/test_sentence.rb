# Title:        StanfordMaxEnt<p>
# Description:  A Maximum Entropy Toolkit<p>
# Copyright:    Copyright (c) Kristina Toutanova<p>
# Company:      Stanford University<p>

class MaxentTagger

  # @author Kristina Toutanova
  # @author Michel Galley
  # @version 1.0
  #
  class TestSentence

    def initialize(maxentTagger)
      raise NotImplementedError
    end

    def tagSentence(s, reuseTags) # TestSentence.java:104
      raise NotImplementedError
    end

  end
end
