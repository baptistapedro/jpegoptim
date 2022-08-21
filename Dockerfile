FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev 	libtool autotools-dev automake
RUN wget https://www.ijg.org/files/jpegsrc.v9e.tar.gz
RUN tar xvfz jpegsrc.v9e.tar.gz
WORKDIR /jpeg-9e
RUN ./configure CC=afl-clang CXX=afl-clang++
RUN make
RUN make install
WORKDIR /
RUN git clone  git clone https://github.com/tjko/jpegoptim.git
WORKDIR /jpegoptim
RUN ./configure CC=aflc-algn CXX=afl-clang++
RUN make
RUN make install
RUN mkdir /jpegoptimCorpus
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg
RUN mv *.jpg /jpegoptimCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/jpegoptimCorpus", "-o", "/jpegoptimOut"]
CMD ["/usr/local/lib/jpegoptim", "@@"]
