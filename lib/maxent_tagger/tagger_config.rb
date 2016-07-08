require "maxent_tagger/properties"

class MaxentTagger
  class TaggerConfig < Properties
    SEARCH = "qn"
    TAG_SEPARATOR = "/"
    TOKENIZE = "true"
    DEBUG = "false"
    ITERATIONS = "100"
    ARCH = ""
    WORD_FUNCTION = ""
    RARE_WORD_THRESH = "5"
    MIN_FEATURE_THRESH = "5"
    CUR_WORD_MIN_FEATURE_THRESH = "2"
    RARE_WORD_MIN_FEATURE_THRESH = "10"
    VERY_COMMON_WORD_THRESH = "250"
    OCCURRING_TAGS_ONLY = "false"
    POSSIBLE_TAGS_ONLY = "false"
    SIGMA_SQUARED = "0.5" # String.valueOf(0.5)
    ENCODING = "UTF-8"
    LEARN_CLOSED_CLASS = "false"
    CLOSED_CLASS_THRESHOLD = "40"
    VERBOSE = "false"
    VERBOSE_RESULTS = "true"
    SGML = "false"
    LANG = ""
    TOKENIZER_FACTORY = ""
    XML_INPUT = ""
    TAG_INSIDE = ""
    APPROXIMATE = "-1.0"
    TOKENIZER_OPTIONS = ""
    DEFAULT_REG_L1 = "1.0"
    OUTPUT_FILE = ""
    OUTPUT_FORMAT = "slashTags"
    OUTPUT_FORMAT_OPTIONS = ""
    NTHREADS = "1"


    def self.readConfig(rf)
      stream_in = ObjectInputStream.new(rf)
      stream_in.readObject # (TaggerConfig)
    end

    def setProperties(config)
      raise NotImplementedError
    end

    def getVerbose
      raise NotImplementedError
    end

    def getLang
      raise NotImplementedError
    end

    def getArch
      raise NotImplementedError
    end

    def getOpenClassTags
      raise NotImplementedError
    end

    def getClosedClassTags
      raise NotImplementedError
    end

    def getWordFunction
      raise NotImplementedError
    end

    def getRareWordThresh
      raise NotImplementedError
    end

    def getMinFeatureThresh
      raise NotImplementedError
    end

    def getCurWordMinFeatureThresh
      raise NotImplementedError
    end

    def getRareWordMinFeatureThresh
      raise NotImplementedError
    end

    def getVeryCommonWordThresh
      raise NotImplementedError
    end

    def occurringTagsOnly
      raise NotImplementedError
    end

    def possibleTagsOnly
      raise NotImplementedError
    end

    def getDefaultScore
      raise NotImplementedError
    end

    def getMode
      # TRAIN, TEST, TAG, DUMP
      raise NotImplementedError
    end

    def getLearnClosedClassTags
      raise NotImplementedError
    end

  end
end
