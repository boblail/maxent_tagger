# Title:        StanfordMaxEnt<p>
# Description:  A Maximum Entropy Toolkit<p>
# Copyright:    Copyright (c) Kristina Toutanova<p>
# Company:      Stanford University<p>

class MaxentTagger

  # Maintains a set of feature extractors and applies them.
  #
  # @author Kristina Toutanova
  # @version 1.0
  #
  class Extractors

    attr_reader :v

    # transient List<Pair<Integer,Extractor>>
    #   local, // extractors only looking at current word
    #   localContext, // extractors only looking at words, except those in "local"
    #   dynamic; // extractors depending on class labels

    def initialize(extrs)
      # v = new Extractor[extrs.length];
      # System.arraycopy(extrs, 0, v, 0, extrs.length);
      @v = extrs.dup
      initTypes
    end

    # Determine type of each feature extractor.
    def initTypes
      raise NotImplementedError
      # local = new ArrayList<>();
      # localContext = new ArrayList<>();
      # dynamic = new ArrayList<>();
      #
      # for(int i=0; i<v.length; ++i) {
      #   Extractor e = v[i];
      #   if(e.isLocal() && e.isDynamic())
      #     throw new RuntimeException("Extractors can't both be local and dynamic!");
      #   if(e.isLocal()) {
      #     local.add(Pair.makePair(i,e));
      #     //localContext.put(i,e);
      #   } else if(e.isDynamic()) {
      #     dynamic.add(Pair.makePair(i,e));
      #   } else {
      #     localContext.add(Pair.makePair(i,e));
      #   }
      # }
      # if(DEBUG) {
      #   log.info("Extractors: "+this);
      #   System.err.printf("Local: %d extractors\n",local.size());
      #   System.err.printf("Local context: %d extractors\n",localContext.size());
      #   System.err.printf("Dynamic: %d extractors\n",dynamic.size());
      # }
    end

  end
end
