# MaxentTagger

Attempt to port [Stanford's "Maximum Entropy" part-of-speech tagger](https://github.com/stanfordnlp/CoreNLP/tree/master/src/edu/stanford/nlp/tagger) to Ruby.

Contribute by cloning the project and running `bin/start`

```bash
git clone git@github.com:boblail/maxent_tagger.git
cd maxent_tagger
bundle
bin/start
```

`bin/start` should throw a `NotImplementedError` at the next method that needs to be ported.

### Roadblock

I've hit a significant Roadblock. Two objects (`TaggerConfig` and `Extractors`) are serialized with [ObjectOutputStream](https://docs.oracle.com/javase/7/docs/api/java/io/ObjectOutputStream.html) which is [apparently nigh impossible to deserialize outside the JVM](http://stackoverflow.com/questions/29505/deserialize-in-a-different-language).

Possible ways forward:

 - [Java Object Serialization Specification](https://docs.oracle.com/javase/7/docs/platform/serialization/spec/serialTOC.html)
 - This problem could be surmounted if these two object could be serialized differently. Perhaps a binary could convert modelFiles produced by Stanford's library to a more generically-serialized format.
