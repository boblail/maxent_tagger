# Title:        StanfordMaxEnt<p>
# Description:  A Maximum Entropy Toolkit<p>
# Copyright:    Copyright (c) Kristina Toutanova<p>
# Company:      Stanford University<p>


# This class serves as the base class for classes which extract relevant
# information from a history to give it to the features. Every feature has
# an associated extractor or maybe more.  GlobalHolder keeps all the
# extractors; two histories are considered equal if all extractors return
# equal values for them.  The main functionality of the Extractors is
# provided by the method extract which takes a History as an argument.
# The Extractor looks at the history and takes out something important for
# the features - e.g. specific words and tags at specific positions or
# some function of the History. The histories are effectively vectors
# of values, with each dimension being the output of some extractor.
# <p>
# New extractors are created in either ExtractorFrames or
# ExtractorFramesRare; those are the places you want to consider
# adding your new extractor.  For a new Extractor, typically the things
# that you have to define are:
# <ul>
# <li>leftContext() and/or rightContext() if the extractor uses the tag
# sequence to the left or right (so that dynamic programming will be done
# correctly.
# <li>isLocal() Return true iff the function is only of the current word
# (for efficiency)
# <li>isDynamic() Return true if a function of any tags (for efficiency)
# <li>extract(History, PairsHolder) The actual function that returns the
# value for the feature.
# </ul>
# <p>
# Note that some extractors can be reused across multiple taggers,
# but many cannot.  Any extractor that uses information from the
# tagger such as its dictionary, for example, cannot.  For the
# moment, some of the extractors in ExtractorFrames and
# ExtractorFramesRare are static; those are all reusable at the
# moment, but if you change them in any way to make them not
# reusable, make sure to change the way they are constructed as well.
#
# @author Kristina Toutanova
# @version 1.0
#
class Extractor # implements Serializable
end
