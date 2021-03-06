# A CoreLabel represents a single word with ancillary information
# attached using CoreAnnotations.
# A CoreLabel also provides convenient methods to access tags,
# lemmas, etc. (if the proper annotations are set).
# <p>
# A CoreLabel is a Map from keys (which are Class objects) to values,
# whose type is determined by the key.  That is, it is a heterogeneous
# typesafe Map (see Josh Bloch, Effective Java, 2nd edition).
# <p>
# The CoreLabel class in particular bridges the gap between old-style JavaNLP
# Labels and the new CoreMap infrastructure.  Instances of this class can be
# used (almost) anywhere that the now-defunct FeatureLabel family could be
# used.  This data structure is backed by an {@link ArrayCoreMap}.
#
# @author dramage
# @author rafferty
#
class CoreLabel

  def setValue(value) # CoreLabel.java:319
    raise NotImplementedError
  end

  # Set the word value for the label.  Also, clears the lemma, since
  # that may have changed if the word changed.
  def setWord(word) # CoreLabel.java:336
    raise NotImplementedError
  end

end
