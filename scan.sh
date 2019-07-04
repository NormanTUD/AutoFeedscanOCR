#!/bin/bash

STARTPDF=$(perl tests.pl get_start_pdf)

echo "STARTING AT $STARTPDF"

scanimage --batch --batch-start=$STARTPDF --source="ADF Duplex" --resolution 300 --format=jpeg --mode Color &

sleep 20

{
	CONTINUE=1
	COUNT=0

	rm .out*.not_blank

	while [ $CONTINUE ]; do
		for FILENAME in *.jpg; do
			if [ -f $FILENAME ]; then
				mkdir -p "blanks"
				NOTBLANK=".$FILENAME.not_blank"

				if [ ! -f $NOTBLANK ]; then

					if perl tests.pl is_blank $FILENAME; then
						mv $FILENAME blanks/
					else
						BASENAME=$(basename $FILENAME .jpg)
						PDFFILE=$BASENAME.pdf
						if [ ! -f $PDFFILE ]; then
							echo "Trying to OCR $PDFFILE..."
							while perl tests.pl not_ready_for_new_forks; do
								echo "Too many open forks, waiting for some of them to finish"
								sleep 1
							done
							tesseract -l deu $FILENAME $BASENAME pdf &
							COUNT=0
						fi
						echo "NOT BLANK" > $NOTBLANK
					fi
				fi
			fi
			COUNT=$((COUNT+1))
		done
		sleep 1
		if perl tests.pl every_jpg_has_nonempty_pdf; then
			echo "FINISHED OCR!!!"
			exit
		fi
		echo $COUNT
	done
} &

rm gesamt.pdf
pdftk *.pdf cat output gesamt.pdf
