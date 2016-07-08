class MaxentTagger
  class Properties

    def initialize
      @hash = {}
    end

    # returns null if the property is not found
    # https://docs.oracle.com/javase/7/docs/api/java/util/Properties.html#getProperty(java.lang.String)
    def getProperty(key)
      @hash[key]
    end

  end
end
