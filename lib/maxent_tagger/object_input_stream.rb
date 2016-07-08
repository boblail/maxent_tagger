class MaxentTagger
  # https://docs.oracle.com/javase/7/docs/api/java/io/ObjectInputStream.html
  class ObjectInputStream

    def initialize(stream)
      @stream = stream
    end

    # Used to deserialize TaggerConfig and Extractors
    # Is an internal representation of a Java object
    # http://stackoverflow.com/a/29524
    # Sadly, cannot likely be deserialized.
    def readObject
      raise NotImplementedError, <<-STR

        \e[91m
        I'm afraid this might not work.
        > you need access to the original class definitions (and a)
        > Java runtime to load them into) to turn the stream data back
        > something approaching the original objects.
        \e[0m
      STR
    end

  end
end
