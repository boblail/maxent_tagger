class MaxentTagger

  # This class holds the POS tags, assigns them unique ids, and knows which tags
  # are open versus closed class.
  # <p/>
  # Title:        StanfordMaxEnt<p>
  # Description:  A Maximum Entropy Toolkit<p>
  # Company:      Stanford University<p>
  #
  # @author Kristina Toutanova
  # @version 1.0
  #
  class TTags

    def initialize(lang=nil)
      raise NotImplementedError
    end

    def setOpenClassTags
      raise NotImplementedError
    end

    def getIndex
      raise NotImplementedError
    end

  end
end
