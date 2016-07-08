# AmbiguityClasses -- StanfordMaxEnt, A Maximum Entropy Toolkit
# Copyright (c) 2002-2008 Leland Stanford Junior University


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
# Support/Questions: java-nlp-user@lists.stanford.edu
# Licensing: java-nlp-support@lists.stanford.edu
# http:# www-nlp.stanford.edu/software/tagger.shtml


require "maxent_tagger/ambiguity_class"


# A collection of Ambiguity Class.
# <i>The code currently here is rotted and would need to be revived.</i>
#
# @author Kristina Toutanova
# @version 1.0

# TODO: if it's rotted and not used anywhere, can we just get rid of it all?  [CDM: It would be nice to keep and revive someday. It is a nice and sometimes useful idea.]


class MaxentTagger
  class AmbiguityClasses

    def initialize(ttags)
      raise NotImplementedError
    end

  end
end
