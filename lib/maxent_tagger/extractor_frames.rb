# ExtractorFrames -- StanfordMaxEnt, A Maximum Entropy Toolkit
# Copyright (c) 2002-2011 Leland Stanford Junior University

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# For more information, bug reports, fixes, contact:
# Christopher Manning
# Dept of Computer Science, Gates 1A
# Stanford CA 94305-9010
# USA
#     Support/Questions: java-nlp-user@lists.stanford.edu
#     Licensing: java-nlp-support@lists.stanford.edu
# http://www-nlp.stanford.edu/software/tagger.shtml


require "maxent_tagger/extractor"


# This class contains the basic feature extractors used for all words and
# tag sequences (and interaction terms) for the MaxentTagger, but not the
# feature extractors explicitly targeting generalization for rare or unknown
# words.
# The following options are supported:
# <table>
# <tr><td>Name</td><td>Args</td><td>Effect</td></tr>
# <tr><td>words</td><td>begin, end</td>
#     <td>Individual features for words begin ... end.
#     If just one argument words(-2) is given, then end is taken as 0. If
#     begin is not less than or equal to end, no features are made.</td></tr>
# <tr><td>tags</td><td>begin, end</td>
#     <td>Individual features for tags begin ... end</td></tr>
# <tr><td>biword</td><td>w1, w2</td>
#     <td>One feature for the pair of words w1, w2</td></tr>
# <tr><td>biwords</td><td>begin, end</td>
#     <td>One feature for each sequential pair of words
#         from begin to end</td></tr>
# <tr><td>twoTags</td><td>t1, t2</td>
#     <td>One feature for the pair of tags t1, t2</td></tr>
# <tr><td>lowercasewords</td><td>begin, end</td>
#     <td>One feature for each word begin ... end, lowercased</td></tr>
# <tr><td>order</td><td>left, right</td>
#     <td>A feature for tags left through 0 and a feature for
#         tags 0 through right.  Lower order left and right features are
#         also added.
#         This gets very expensive for higher order terms.</td></tr>
# <tr><td>wordTag</td><td>w, t</td>
#     <td>A feature combining word w and tag t.</td></tr>
# <tr><td>wordTwoTags</td><td>w, t1, t2</td>
#     <td>A feature combining word w and tags t1, t2.</td></tr>
# <tr><td>threeTags</td><td>t1, t2, t3</td>
#     <td>A feature combining tags t1, t2, t3.</td></tr>
# <tr><td>vbn</td><td>length</td>
#     <td>A feature that looks at the left length words for something that
#         appears to be a VBN (in English) without looking at the actual tags.
#         It is zeroeth order, as it does not look at the tag predictions.
#         It also is never used, since it doesn't seem to help.</td></tr>
# <tr><td>allwordshapes</td><td>left, right</td>
#     <td>Word shape features, eg transform Foo5 into Xxx#
#         (not exactly like that, but that general idea).
#         Creates individual features for each word left ... right.
#         Compare with the feature "wordshapes" in ExtractorFramesRare,
#         which is only applied to rare words. Fairly English-specific.
#         Slightly increases accuracy.</td></tr>
# <tr><td>allunicodeshapes</td><td>left, right</td>
#     <td>Same thing, but works for unicode characters more generally.</td></tr>
# <tr><td>allunicodeshapeconjunction</td><td>left, right</td>
#     <td>Instead of individual word shape features, combines several
#         word shapes into one feature.</td></tr>
# </table>
#
# See {@link ExtractorFramesRare} for more options.
# <br>
# There are also macro features:
# <br>
# left3words = words(-1,1),order(2) <br>
# left5words = words(-2,2),order(2) <br>
# generic = words(-1,1),order(2),biwords(-1,0),wordTag(0,-1) <br>
# bidirectional5words =
#   words(-2,2),order(-2,2),twoTags(-1,1),
#   wordTag(0,-1),wordTag(0,1),biwords(-1,1) <br>
# bidirectional =
#   words(-1,1),order(-2,2),twoTags(-1,1),
#   wordTag(0,-1),wordTag(0,1),biwords(-1,1) <br>
# german = some random stuff <br>
# sighan2005 = some other random stuff <br>
# The left3words architectures are faster, but slightly less
# accurate, than the bidirectional architectures.
# 'naacl2003unknowns' was our traditional set of unknown word
# features, but you can now specify features more flexibility via the
# various other supported keywords.
# <br>
# @author Kristina Toutanova
# @author Michel Galley
# @version 1.0
#
class ExtractorFrames
end
