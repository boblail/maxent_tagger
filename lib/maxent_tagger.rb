# MaxentTagger -- StanfordMaxEnt, A Maximum Entropy Toolkit
# Copyright (c) 2002-2016 Leland Stanford Junior University


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
# Dept of Computer Science, Gates 2A
# Stanford CA 94305-9020
# USA
# Support/Questions: stanford-nlp on SO or java-nlp-user@lists.stanford.edu
# Licensing: java-nlp-support@lists.stanford.edu
# http://www-nlp.stanford.edu/software/tagger.shtml

require "pry"

require "maxent_tagger/properties"
require "maxent_tagger/data_input_stream"
require "maxent_tagger/object_input_stream"

require "maxent_tagger/ambiguity_classes"
require "maxent_tagger/extractors"
require "maxent_tagger/extractor_frames"
require "maxent_tagger/extractor_frames_rare"
require "maxent_tagger/dictionary"
require "maxent_tagger/tagger_config"
require "maxent_tagger/ttags"

require "maxent_tagger/version"



# The main class for users to run, train, and test the part of speech tagger.
#
# You can tag things through the Java API or from the command line.
# The two English taggers included in this distribution are:
# <ul>
# <li> A bi-directional dependency network tagger in
#      {@code edu/stanford/nlp/models/pos-tagger/english-left3words/english-bidirectional-distsim.tagger}.
#      Its accuracy was 97.32% on Penn Treebank WSJ secs. 22-24.</li>
# <li> A model using only left second-order sequence information and similar but less
#      unknown words and lexical features as the previous model in
#      {@code edu/stanford/nlp/models/pos-tagger/english-left3words/english-left3words-distsim.tagger}
#      This tagger runs a lot faster, and is recommended for general use.
#      Its accuracy was 96.92% on Penn Treebank WSJ secs. 22-24.</li>
# </ul>
#
# <h3>Using the Java API</h3>
# <dl>
# <dt>
# A MaxentTagger can be made with a constructor taking as argument the location of parameter files for a trained tagger: </dt>
# <dd> <code>MaxentTagger tagger = new MaxentTagger("models/left3words-wsj-0-18.tagger");</code></dd>
# <p>
# <dt>A default path is provided for the location of the tagger on the Stanford NLP machines:</dt>
# <dd><code>MaxentTagger tagger = new MaxentTagger(DEFAULT_NLP_GROUP_MODEL_PATH); </code></dd>
# <p>
# <dt>If you set the NLP_DATA_HOME environment variable,
# DEFAULT_NLP_GROUP_MODEL_PATH will instead point to the directory
# given in NLP_DATA_HOME.</dt>
# <p>
# <dt>To tag a List of HasWord and get a List of TaggedWord, you can use one of: </dt>
# <dd><code>List&lt;TaggedWord&gt; taggedSentence = tagger.tagSentence(List&lt;? extends HasWord&gt; sentence)</code></dd>
# <dd><code>List&lt;TaggedWord&gt; taggedSentence = tagger.apply(List&lt;? extends HasWord&gt; sentence)</code></dd>
# <p>
# <dt>To tag a list of sentences and get back a list of tagged sentences:
# <dd><code> List taggedList = tagger.process(List sentences)</code></dd>
# <p>
# <dt>To tag a String of text and to get back a String with tagged words:</dt>
# <dd> <code>String taggedString = tagger.tagString("Here's a tagged string.")</code></dd>
# <p>
# <dt>To tag a string of <i>correctly tokenized</i>, whitespace-separated words and get a string of tagged words back:</dt>
# <dd> <code>String taggedString = tagger.tagTokenizedString("Here 's a tagged string .")</code></dd>
# </dl>
# <p>
# The <code>tagString</code> method uses the default tokenizer (PTBTokenizer).
# If you wish to control tokenization, you may wish to call
# {@link #tokenizeText(Reader, TokenizerFactory)} and then to call
# <code>process()</code> on the result.
# </p>
#
# <h3>Using the command line</h3>
#
# Tagging, testing, and training can all also be done via the command line.
# <h3>Training from the command line</h3>
# To train a model from the command line, first generate a property file:
# <pre>java edu.stanford.nlp.tagger.maxent.MaxentTagger -genprops </pre>
#
# This gets you a default properties file with descriptions of each parameter you can set in
# your trained model.  You can modify the properties file, or use the default options.  To train, run:
# <pre>java -mx1g edu.stanford.nlp.tagger.maxent.MaxentTagger -props myPropertiesFile.props </pre>
#
#  with the appropriate properties file specified. Any argument you give in the properties file can also
#  be specified on the command line.  You must have specified a model using -model, either in the properties file
#  or on the command line, as well as a file containing tagged words using -trainFile.
#
# Useful flags for controlling the amount of output are -verbose, which prints extra debugging information,
# and -verboseResults, which prints full information about intermediate results.  -verbose defaults to false
# and -verboseResults defaults to true.
#
# <h3>Tagging and Testing from the command line</h3>
#
# Usage:
# For tagging (plain text):
# <pre>java edu.stanford.nlp.tagger.maxent.MaxentTagger -model &lt;modelFile&gt; -textFile &lt;textfile&gt; </pre>
# For testing (evaluating against tagged text):
# <pre>java edu.stanford.nlp.tagger.maxent.MaxentTagger -model &lt;modelFile&gt; -testFile &lt;testfile&gt; </pre>
# You can use the same properties file as for training
# if you pass it in with the "-props" argument. The most important
# arguments for tagging (besides "model" and "file") are "tokenize"
# and "tokenizerFactory". See below for more details.
# <br>
# Note that the tagger assumes input has not yet been tokenized and
# by default tokenizes it using a default English tokenizer.  If your
# input has already been tokenized, use the flag "-tokenize false".
#
# <p> Parameters can be defined using a Properties file
# (specified on the command-line with <code>-prop</code> <i>propFile</i>),
# or directly on the command line (by preceding their name with a minus sign
# ("-") to turn them into a flag. The following properties are recognized:
# </p>
# <table border="1">
# <tr><td><b>Property Name</b></td><td><b>Type</b></td><td><b>Default Value</b></td><td><b>Relevant Phase(s)</b></td><td><b>Description</b></td></tr>
# <tr><td>model</td><td>String</td><td>N/A</td><td>All</td><td>Path and filename where you would like to save the model (training) or where the model should be loaded from (testing, tagging).</td></tr>
# <tr><td>trainFile</td><td>String</td><td>N/A</td><td>Train</td>
#     <td>
#       Path to the file holding the training data; specifying this option puts the tagger in training mode.  Only one of 'trainFile','testFile','textFile', and 'dump' may be specified.<br>
#       There are three formats possible.  The first is a text file of tagged data. Each line is considered a separate sentence.  In each sentence, words are separated by whitespace.  Each word must have a tag, which is separated from the token using the specified {@code tagSeparator}.  This format, called TEXT, is the default format.<br />
#       The second format is a file of Penn Treebank formatted tree files.  Trees are loaded one at a time and the tagged words in a tree are used as a training sentence.  To specify this format, preface the filename with "{@code format=TREES,}".  <br />
#       The final possible format is TSV files (tab-separated columns).  To specify a TSV file, set {@code trainFile} to "{@code format=TSV,wordColumn=x,tagColumn=y,filename}".  Column numbers are indexed from 0, and sentences are separated with blank lines. The default wordColumn is 0 and default tagColumn is 1.
#       <br>
#       A file can be in a different character set encoding than the tagger's default encoding by prefacing the filename with {@code "encoding=ENC"}.
#       You can specify the tagSeparator character in a TEXT file by prefacing the filename with "tagSeparator=c". <br/>
#       Tree files can be fed through TreeTransformers and TreeNormalizers.  To specify a transformer, preface the filename with "treeTransformer=CLASSNAME".  To specify a normalizer, preface the filename with "treeNormalizer=CLASSNAME".
#       You can also filter trees using a Filter&lt;Tree&gt;, which can be specified with "treeFilter=CLASSNAME".  A specific range of trees to be used can be specified with treeRange=X-Y.  Multiple parts of the range can be separated by : as opposed to the normal separator of ,.
#       For example, one could use the argument "-treeRange=25-50:75-100". You can specify a TreeReaderFactory by prefacing the filename with "trf=CLASSNAME". <br>
#       Multiple files can be specified by making a semicolon separated list of files.  Each file can have its own format specifiers as above.<br>
#       You will note that none of , ; or = can be in filenames.
#     </td>
#   </tr>
# <tr><td>testFile</td><td>String</td><td>N/A</td><td>Test</td><td>Path to the file holding the test data; specifying this option puts the tagger in testing mode.  Only one of 'trainFile','testFile','textFile', and 'dump' may be specified.  The same format as trainFile applies, but only one file can be specified.</td></tr>
# <tr><td>textFile</td><td>String</td><td>N/A</td><td>Tag</td><td>Path to the file holding the text to tag; specifying this option puts the tagger in tagging mode.  Only one of 'trainFile','testFile','textFile', and 'dump' may be specified.  No file reading options may be specified for textFile</td></tr>
# <tr><td>dump</td><td>String</td><td>N/A</td><td>Dump</td><td>Path to the file holding the model to dump; specifying this option puts the tagger in dumping mode.  Only one of 'trainFile','testFile','textFile', and 'dump' may be specified.</td></tr>
# <tr><td>genprops</td><td>boolean</td><td>N/A</td><td>N/A</td><td>Use this option to output a default properties file, containing information about each of the possible configuration options.</td></tr>
# <tr><td>tagSeparator</td><td>char</td><td>/</td><td>All</td><td>Separator character that separates word and part of speech tags, such as out/IN or out_IN.  For training and testing, this is the separator used in the train/test files.  For tagging, this is the character that will be inserted between words and tags in the output.</td></tr>
# <tr><td>encoding</td><td>String</td><td>UTF-8</td><td>All</td><td>Encoding of the read files (training, testing) and the output text files.</td></tr>
# <tr><td>tokenize</td><td>boolean</td><td>true</td><td>Tag,Test</td><td>Whether or not the file needs to be tokenized.  If this is false, the tagger assumes that white space separates words if and only if they should be tagged as separate tokens, and that the input is strictly one sentence per line.</td></tr>
# <tr><td>tokenizerFactory</td><td>String</td><td>edu.stanford.nlp.<br>process.PTBTokenizer</td><td>Tag,Test</td><td>Fully qualified class name of the tokenizer to use.  edu.stanford.nlp.process.PTBTokenizer does basic English tokenization.</td></tr>
# <tr><td>tokenizerOptions</td><td>String</td><td></td><td>Tag,Test</td><td>Known options for the particular tokenizer used. A comma-separated list. For PTBTokenizer, options of interest include <code>americanize=false</code> and <code>asciiQuotes</code> (for German). Note that any choice of tokenizer options that conflicts with the tokenization used in the tagger training data will likely degrade tagger performance.</td></tr>
# <tr><td>sentenceDelimiter</td><td>String</td><td>null</td><td>Tag,Test</td><td>A marker used to separate a text into sentences. If not set (equal to <code>null</code>), sentence breaking is done by content (looking for periods, etc.) Otherwise, it will break on this String, except that if the String is "newline", it breaks on the String "\\n".</td></tr>
# <tr><td>arch</td><td>String</td><td>generic</td><td>Train</td><td>Architecture of the model, as a comma-separated list of options, some with a parenthesized integer argument written k here: this determines what features are used to build your model.  See {@link ExtractorFrames} and {@link ExtractorFramesRare} for more information.</td></tr>
# <tr><td>wordFunction</td><td>String</td><td>(none)</td><td>Train</td><td>A function to apply to the text before training or testing.  Must inherit from edu.stanford.nlp.util.Function&lt;String, String&gt;.  Can be blank.</td></tr>
# <tr><td>lang</td><td>String</td><td>english</td><td>Train</td><td>Language from which the part of speech tags are drawn. This option determines which tags are considered closed-class (only fixed set of words can be tagged with a closed-class tag, such as prepositions). Defined languages are 'english' (Penn tag set), 'polish' (very rudimentary), 'french', 'chinese', 'arabic', 'german', and 'medline'.  </td></tr>
# <tr><td>openClassTags</td><td>String</td><td>N/A</td><td>Train</td><td>Space separated list of tags that should be considered open-class.  All tags encountered that are not in this list are considered closed-class.  E.g. format: "NN VB"</td></tr>
# <tr><td>closedClassTags</td><td>String</td><td>N/A</td><td>Train</td><td>Space separated list of tags that should be considered closed-class.  All tags encountered that are not in this list are considered open-class.</td></tr>
# <tr><td>learnClosedClassTags</td><td>boolean</td><td>false</td><td>Train</td><td>If true, induce which tags are closed-class by counting as closed-class tags all those tags which have fewer unique word tokens than closedClassTagThreshold. </td></tr>
# <tr><td>closedClassTagThreshold</td><td>int</td><td>int</td><td>Train</td><td>Number of unique word tokens that a tag may have and still be considered closed-class; relevant only if learnClosedClassTags is true.</td></tr>
# <tr><td>sgml</td><td>boolean</td><td>false</td><td>Tag, Test</td><td>Very basic tagging of the contents of all sgml fields; for more complex mark-up, consider using the xmlInput option.</td></tr>
# <tr><td>xmlInput</td><td>String</td><td></td><td>Tag, Test</td><td>Give a space separated list of tags in an XML file whose content you would like tagged.  Any internal tags that appear in the content of fields you would like tagged will be discarded; the rest of the XML will be preserved and the original text of specified fields will be replaced with the tagged text.</td></tr>
# <tr><td>outputFile</td><td>String</td><td>""</td><td>Tag</td><td>Path to write output to.  If blank, stdout is used.</td></tr>
# <tr><td>outputFormat</td><td>String</td><td>""</td><td>Tag</td><td>Output format. One of: slashTags (default), xml, or tsv</td></tr>
# <tr><td>outputFormatOptions</td><td>String</td><td>""</td><td>Tag</td><td>Output format options.</td></tr>
# <tr><td>tagInside</td><td>String</td><td>""</td><td>Tag</td><td>Tags inside elements that match the regular expression given in the String.</td></tr>
# <tr><td>search</td><td>String</td><td>cg</td><td>Train</td><td>Specify the search method to be used in the optimization method for training.  Options are 'cg' (conjugate gradient), 'iis' (improved iterative scaling), or 'qn' (quasi-newton).</td></tr>
# <tr><td>sigmaSquared</td><td>double</td><td>0.5</td><td>Train</td><td>Sigma-squared smoothing/regularization parameter to be used for conjugate gradient search.  Default usually works reasonably well.</td></tr>
# <tr><td>iterations</td><td>int</td><td>100</td><td>Train</td><td>Number of iterations to be used for improved iterative scaling.</td></tr>
# <tr><td>rareWordThresh</td><td>int</td><td>5</td><td>Train</td><td>Words that appear fewer than this number of times during training are considered rare words and use extra rare word features.</td></tr>
# <tr><td>minFeatureThreshold</td><td>int</td><td>5</td><td>Train</td><td>Features whose history appears fewer than this number of times are discarded.</td></tr>
# <tr><td>curWordMinFeatureThreshold</td><td>int</td><td>2</td><td>Train</td><td>Words that occur more than this number of times will generate features with all of the tags they've been seen with.</td></tr>
# <tr><td>rareWordMinFeatureThresh</td><td>int</td><td>10</td><td>Train</td><td>Features of rare words whose histories occur fewer than this number of times are discarded.</td></tr>
# <tr><td>veryCommonWordThresh</td><td>int</td><td>250</td><td>Train</td><td>Words that occur more than this number of times form an equivalence class by themselves.  Ignored unless you are using ambiguity classes.</td></tr>
# <tr><td>debug</td><td>boolean</td><td>boolean</td><td>All</td><td>Whether to write debugging information (words, top words, unknown words, confusion matrix).  Useful for error analysis.</td></tr>
# <tr><td>debugPrefix</td><td>String</td><td>N/A</td><td>All</td><td>File (path) prefix for where to write out the debugging information (relevant only if debug=true).</td></tr>
# <tr><td>nthreads</td><td>int</td><td>1</td><td>Test,Text</td><td>Number of threads to use when processing text.</td></tr>
# </table>
# <p/>
#
# @author Kristina Toutanova
# @author Miler Lee
# @author Joseph Smarr
# @author Anna Rafferty
# @author Michel Galley
# @author Christopher Manning
# @author John Bauer
#
class MaxentTagger
  attr_reader :dict,
              :tags,

              # Determines which words are considered rare.  All words with count
              # in the training data strictly less than this number (standardly, &lt; 5) are
              # considered rare.
              :rareWordThresh,

              # Determines which features are included in the model.  The model
              # includes features that occurred strictly more times than this number
              # (standardly, &gt; 5) in the training data.  Here I look only at the
              # history (not the tag), so the history appearing this often is enough.
              :minFeatureThresh,

              # This is a special threshold for the current word feature.
              # Only words that have occurred strictly &gt; this number of times
              # in total will generate word features with all of their occurring tags.
              # The traditional default was 2.
              :curWordMinFeatureThresh,

              # Determines which rare word features are included in the model.
              # The features for rare words have a strictly higher support than
              # this number are included. Traditional default is 10.
              :rareWordMinFeatureThresh,

              # If using tag equivalence classes on following words, words that occur
              # strictly more than this number of times (in total with any tag)
              # are sufficiently frequent to form an equivalence class
              # by themselves. (Not used unless using equivalence classes.)
              #
              # There are places in the code (ExtractorAmbiguityClass.java, for one)
              # that assume this value is constant over the life of a tagger.
              :veryCommonWordThresh,

              :xSize,
              :ySize,
              :occurringTagsOnly,
              :possibleTagsOnly,

              # This is a function used to preprocess all text before applying
              # the tagger to it.  For example, it could be a function to
              # lowercase text, such as edu.stanford.nlp.util.LowercaseFunction
              # (which makes the tagger case insensitive).  It is applied in
              # ReadDataTagged, which loads in the training data, and in
              # TestSentence, which processes sentences for new queries.  If any
              # other classes are added or modified which use raw text, they must
              # also use this function to keep results consistent.
              # <br>
              # An alternate design would have been to use the function at a
              # lower level, such as at the extractor level.  That would have
              # require more invasive changes to the tagger, though, because
              # other data structures such as the Dictionary would then be using
              # raw text as well.  This is also more efficient, in that the
              # function is applied once at the start of the process.
              :wordFunction # Function<String, String>

  def initialize(modelFile)                                                     # MaxentTagger.java:265
    @dict = Dictionary.new

    @rareWordThresh = TaggerConfig::RARE_WORD_THRESH.to_i                       # MaxentTagger.java:391
    @minFeatureThresh = TaggerConfig::MIN_FEATURE_THRESH.to_i                   # MaxentTagger.java:399
    @curWordMinFeatureThresh = TaggerConfig::CUR_WORD_MIN_FEATURE_THRESH.to_i   # MaxentTagger.java:407
    @rareWordMinFeatureThresh = TaggerConfig::RARE_WORD_MIN_FEATURE_THRESH.to_i # MaxentTagger.java:414
    @veryCommonWordThresh = TaggerConfig::VERY_COMMON_WORD_THRESH.to_i          # MaxentTagger.java:425

    @occurringTagsOnly = TaggerConfig::OCCURRING_TAGS_ONLY == "true"            # MaxentTagger.java:430
    @possibleTagsOnly = TaggerConfig::POSSIBLE_TAGS_ONLY == "true"              # MaxentTagger.java:431

    readModelAndInit(Properties.new, modelFile, true)                           # MaxentTagger.java:315
  end



  # Returns a new Sentence that is a copy of the given sentence with all the
  # words tagged with their part-of-speech. Convenience method when you only
  # want to tag a single List instead of a Document of sentences.
  # @param sentence sentence to tag
  # @return tagged sentence
  #
  def tagSentence(sentence)                                                     # MaxentTagger.java:1028
    testSentence = TestSentence.new(self)
    testSentence.tagSentence(sentence, false)
  end



private

  attr_reader :prop,                                                            # LambdaSolveTagger

              # For each extractor index, we have a map from possible extracted
              # features to an array which maps from tag number to feature weight index in the lambdas array.
              :fAssociations, # List<Map<String, int[]>>
              :extractors,
              :extractorsRare,
              :ambClasses, # AmbiguityClasses
              :alltags,
              :tagTokens, # Map<String, Set<String>>
              :defaultScore, # double
              :defaultScores, # double[]
              :leftContext,
              :rightContext,
              :config



  # This reads the complete tagger from a single model stored in a file, at a URL,
  #  or as a resource in a jar file, and initializes the tagger using a
  #  combination of the properties passed in and parameters from the file.
  #  <p>
  #  <i>Note for the future:</i> This assumes that the TaggerConfig in the file
  #  has already been read and used.  This work is done inside the
  #  constructor of TaggerConfig.  It might be better to refactor
  #  things so that is all done inside this method, but for the moment
  #  it seemed better to leave working code alone [cdm 2008].
  #
  #  @param config The tagger config
  #  @param model_file The name of the model file. This routine opens and closes it.
  #  @param print_loading Whether to print a message saying what model file is being loaded and how long it took when finished.
  #  @throws RuntimeIOException if I/O errors or serialization errors
  def readModelAndInit(config, modelFile, printLoading) # MaxentTagger.java:840
    File.open(modelFile, "r") do |file|
      rf = DataInputStream.new(file)
      # t = Timing.new
      source = nil

      if printLoading
        if config != nil
          source = config.getProperty("model")
        end
        if source == nil
          source = "data stream"
        end
      end

      taggerConfig = TaggerConfig.readConfig(rf)

      if config != nil
        taggerConfig.setProperties(config)
      end

      # then init tagger
      init(taggerConfig)

      xSize = rf.readInt
      ySize = rf.readInt
      # dict = new Dictionary();  # this method is called in constructor, and it's initialized as empty already
      dict.read(rf)

      puts "Tagger dictionary read." if @verbose

      tags.read(rf)
      readExtractors(rf)
      dict.setAmbClasses(ambClasses, veryCommonWordThresh, tags)

      # int[] numFA = new int[extractors.size() + extractorsRare.size()]
      numFA = [0] * (extractors.length + extractorsRare.length)
      sizeAssoc = rf.readInt
      @fAssociations = [] # Generics.newArrayList()
      (extractors.length + extractorsRare.length).times do
        fAssociations.push Hash.new
      end
      # for (int i = 0; i < extractors.size() + extractorsRare.size(); ++i) {
      #   fAssociations.add(Generics.<String, int[]>newHashMap());
      # }

      puts "Reading #{sizeAssoc} feature keys..." if @verbose

      # PrintFile pfVP = null;
      # if (@verbose) {
      #   pfVP = new PrintFile("pairs.txt");
      # }
      # for (int i = 0; i < sizeAssoc; i++) {
      sizeAssoc.times do |i|
        numF = rf.readInt
        fK = FeatureKey.new
        fK.read(rf)
        numFA[fK.num] += 1

        # TODO: rewrite the writing / reading code to store
        # fAssociations in a cleaner manner?  Only do this when
        # rebuilding all the tagger models anyway.  When we do that, we
        # can get rid of FeatureKey
        fValueAssociations = fAssociations.get(fK.num) # Map<String, int[]>
        fTagAssociations = fValueAssociations.get(fK.val) # int[]
        if fTagAssociations == nil
          fTagAssociations = [] # new int[ySize];
          ySize.times do |j| # for (int j = 0; j < ySize; ++j) {
            fTagAssociations[j] = -1
          end
          fValueAssociations.put(fK.val, fTagAssociations)
        end
        fTagAssociations[tags.getIndex(fK.tag)] = numF
      end

      # if (@verbose) {
      #   IOUtils.closeIgnoringExceptions(pfVP);
      # }

      if @verbose
        numFA.times do |k| # for (int k = 0; k < numFA.length; k++) {
          puts "Number of features of kind #{k} #{numFA[k]}"
        end
      end

      @prob = LambdaSolveTagger.new(rf)

      if @verbose
        puts "prob read "
      end

      if printLoading
        # t.done(log, "Reading POS tagger model from " + source)
        puts "Reading POS tagger model from #{source}"
      end
    end
  end

  def init(config) # MaxentTagger.java:463
    return if @initted # TODO: why not reinit?

    @config = config;

    # String lang, arch;
    # String[] openClassTags, closedClassTags;

    if config == nil
      lang = "english"
      arch = "left3words"
      openClassTags = [].freeze # StringUtils.EMPTY_STRING_ARRAY
      closedClassTags = [].freeze # StringUtils.EMPTY_STRING_ARRAY
      @wordFunction = nil
    else
      @verbose = config.getVerbose

      lang = config.getLang
      arch = config.getArch
      openClassTags = config.getOpenClassTags
      closedClassTags = config.getClosedClassTags
      unless config.getWordFunction.equals("")
        # TODO: load by reflection ...
        binding.pry
        @wordFunction = ReflectionLoading.loadByReflection(config.getWordFunction)
      end

      if (((openClassTags.length > 0) && !lang.equals("")) || ((closedClassTags.length > 0) && !lang.equals("")) || ((closedClassTags.length > 0) && (openClassTags.length > 0)))
        throw ("At least two of lang (\"" + lang + "\"), openClassTags (length " + openClassTags.length + ": " + Arrays.toString(openClassTags) + ")," +
            "and closedClassTags (length " + closedClassTags.length + ": " + Arrays.toString(closedClassTags) + ") specified---you must choose one!");
      elsif ((openClassTags.length == 0) && lang.equals("") && (closedClassTags.length == 0) && ! config.getLearnClosedClassTags())
        puts "warning: no language set, no open-class tags specified, and no closed-class tags specified; assuming ALL tags are open class tags"
      end
    end

    if openClassTags.length > 0
      @tags = TTags.new
      tags.setOpenClassTags(openClassTags)
    elsif closedClassTags.length > 0
      @tags = TTags.new
      tags.setClosedClassTags(closedClassTags)
    else
      @tags = TTags.new(lang)
    end

    @defaultScore = lang == "english" ? 1.0 : 0.0

    if config != nil
      @rareWordThresh = config.getRareWordThresh
      @minFeatureThresh = config.getMinFeatureThresh
      @curWordMinFeatureThresh = config.getCurWordMinFeatureThresh
      @rareWordMinFeatureThresh = config.getRareWordMinFeatureThresh
      @veryCommonWordThresh = config.getVeryCommonWordThresh
      @occurringTagsOnly = config.occurringTagsOnly
      @possibleTagsOnly = config.possibleTagsOnly
      # log.info("occurringTagsOnly: "+occurringTagsOnly)
      # log.info("possibleTagsOnly: "+possibleTagsOnly)

      if config.getDefaultScore >= 0
        @defaultScore = config.getDefaultScore()
      end
    end

    # just in case, reset the defaultScores array so it will be
    # recached later when needed.  can't initialize it now in case we
    # don't know ysize yet
    @defaultScores = nil;

    if config == nil || config.getMode == :TRAIN
      # initialize the extractors based on the arch variable
      # you only need to do this when training; otherwise they will be
      # restored from the serialized file
      @extractors = Extractors.new(ExtractorFrames.getExtractorFrames(arch))
      @extractorsRare = Extractors.new(ExtractorFramesRare.getExtractorFramesRare(arch, tags))

      setExtractorsGlobal
    end

    @ambClasses = AmbiguityClasses.new(tags)

    @initted = true;
  end

  # Sometimes there is data associated with the tagger (such as a
  # dictionary) that we don't want saved with each extractor.  This
  # call lets those extractors get that information from the tagger
  # after being loaded from a data file.
  def setExtractorsGlobal # MaxentTagger.java:646
    extractors.setGlobalHolder(self)
    extractorsRare.setGlobalHolder(self)
  end

  # Read the extractors from a stream.
  def readExtractors(file)
    ObjectInputStream stream_in = ObjectInputStream.new(file)
    @extractors = stream_in.readObject # (Extractors)
    @extractorsRare = stream_in.readObject # (Extractors)
    extractors.initTypes
    extractorsRare.initTypes

    left = extractors.leftContext
    left_u = extractorsRare.leftContext
    left = left_u if left_u > left
    @leftContext = left

    right = extractors.rightContext
    right_u = extractorsRare.rightContext
    right = right_u if right_u > right
    @rightContext = right

    setExtractorsGlobal
  end

end
