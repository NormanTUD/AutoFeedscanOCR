# AutoFeedscanOCR
This script allows to use a Feedscanner (I'm using a Fujitsu ScanSnap S510) in Duplex-Mode and, already while 
scanning, turns the scans into searchable PDFs, skipping blank pages automatically.

In the end, this creates a "gesamt.pdf", in which all of the scanned files are combined into one large searchable
PDF-file.


If you scan in any other language than german, consider changing the scan.sh line

tesseract -l deu $FILENAME $BASENAME pdf &

to the abbreviation of your language (instead of "deu").

Please install scanimage and the latest Tesseract version.

HOW TO INSTALL THE LATEST TESSERACT-VERSION:

apt-get -y install g++ autoconf automake libtool pkg-config libpng-dev libtiff5-dev zlib1g-dev automake ca-certificates g++ git libtool libleptonica-dev make pkg-config asciidoc libpango1.0-dev

mkdir ~/tesseractsource

cd ~/tesseractsource; git clone --depth 1 https://github.com/tesseract-ocr/tesseract.git

cd ~/tesseractsource/tesseract; ./autogen.sh; autoreconf -i; ./configure; make; make install; ldconfig



This code is licensed under the WTFPL.
