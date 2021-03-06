# ExtractorFramesRare -- StanfordMaxEnt, A Maximum Entropy Toolkit
# Copyright (c) 2002-2008 The Board of Trustees of
# Leland Stanford Junior University. All rights reserved.

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
# http:# www-nlp.stanford.edu/software/tagger.shtml


require "maxent_tagger/extractor"


# This class contains feature extractors for the MaxentTagger that are only
# applied to rare (low frequency/unknown) words.
# The following options are supported:
# <table>
# <tr><td>Name</td><td>Args</td><td>Effect</td></tr>
# <tr><td>wordshapes</td><td>left, right</td>
#     <td>Word shape features, e.g., transform Foo5 into Xxx#
#         (not exactly like that, but that general idea).
#         Creates individual features for each word left ... right.
#         If just one argument wordshapes(-2) is given, then end is taken as 0.
#         If left is not less than or equal to right, no features are made.
#         Fairly English-specific.</td></tr>
# <tr><td>unicodeshapes</td><td>left, right</td>
#     <td>Same thing, but works for unicode characters generally.</td></tr>
# <tr><td>unicodeshapeconjunction</td><td>left, right</td>
#     <td>Instead of individual word shape features, combines several
#         word shapes into one feature.</td></tr>
# <tr><td>suffix</td><td>length, position</td>
#     <td>Features for suffixes of the word position.  One feature for
#         each suffix of length 1 ... length.</td></tr>
# <tr><td>prefix</td><td>length, position</td>
#     <td>Features for prefixes of the word position.  One feature for
#         each prefix of length 1 ... length.</td></tr>
# <tr><td>prefixsuffix</td><td>length</td>
#     <td>Features for concatenated prefix and suffix.  One feature for
#         each of length 1 ... length.</td></tr>
# <tr><td>capitalizationsuffix</td><td>length</td>
#     <td>Current word only.  Combines character suffixes up to size length with a
#         binary value for whether the word contains any capital letters.</td></tr>
# <tr><td>distsim</td><td>filename, left, right</td>
#     <td>Individual features for each position left ... right.
#         Compares that word with the dictionary in filename.</td></tr>
# <tr><td>distsimconjunction</td><td>filename, left, right</td>
#     <td>A concatenation of distsim features from left ... right.</td></tr>
# </table>
# Also available are the macros "naacl2003unknowns",
# "lnaacl2003unknowns", and "naacl2003conjunctions".
# naacl2003unknowns and lnaacl2003unknowns include suffix extractors
# and extractors for specific word shape features, such as containing
# or not containing a digit.
# <br>
# The macro "frenchunknowns" is a macro for five extractors specific
# to French, which test the end of the word to see if it matches
# common suffixes for various POS classes and plural words.  Adding
# this experiment did not improve accuracy over the regular
# naacl2003unknowns extractor macro, though.
# <br>
# @author Kristina Toutanova
# @author Christopher Manning
# @author Michel Galley
# @version 2.0
#
class ExtractorFramesRare
end
