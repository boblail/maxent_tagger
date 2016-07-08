class MaxentTagger
  class DataInputStream

    def initialize(bytes)
      @bytes
    end

    # reads a 32-bit signed integer
    # https://www.cis.upenn.edu/~bcpierce/courses/629/jdkdocs/api/java.io.DataInputStream.html#readInt()
    # big-endian
    # http://stackoverflow.com/a/13211787
    def readInt
      @bytes.read(4).unpack("L")[0]
    end

  end
end
