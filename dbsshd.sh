#!/bin/sh

VER="0.1"
DIR=/Users/Valentine/Dropbox/shell_in
TMP_DIR=/Users/Valentine/.tmp_dbssh
DONE_DIR=/Users/Valentine/Dropbox/shell_done
OUT_DIR=/Users/Valentine/Dropbox/shell_out
FILE_MASK=*.sh
OWNER="Valentine Silvansky"
MAIL_LOGIN="v.silvansky"
MAIL_DOMAIN="gmail.com"
MAIL="${MAIL_LOGIN}@${MAIL_DOMAIN}"

TIMEOUT=5
SENDMAIL=false

echo "Starting SSH over Dropbox v$VER daemon with following config:"
echo "  Watch dir:     $DIR"
echo "  Mask           ${FILE_MASK}"
echo "  Temporary dir: ${TMP_DIR}"
echo "  Output dir:    ${OUT_DIR}"
echo "  Done dir:      ${DONE_DIR}"
echo "  Temporary dir: ${TMP_DIR}"
echo "  Owner:         $OWNER <$MAIL>"
echo "  Email notify:  $SENDMAIL"

cd $DIR

while true; do
	FILES=`find . -name ${FILE_MASK}`
	for FILE in $FILES; do
		if [ "$FILE" != "" ]; then
			echo "Found file $FILE"
			DATE=`date +%d-%m-%y`
			TIME=`date +%H-%M`
			TMP_FILE_NAME=${FILE}_${DATE}_${TIME}.sh
			TMP_OUTPUT_NAME=${FILE}_${DATE}_${TIME}_out.txt
			mv $FILE ${TMP_DIR}/${TMP_FILE_NAME}
			echo "Temporary file: ${TMP_FILE_NAME}"
			echo "Temporary output file: ${TMP_OUTPUT_NAME}"
			chmod +x ${TMP_DIR}/${TMP_FILE_NAME}
			${TMP_DIR}/${TMP_FILE_NAME} > ${TMP_DIR}/${TMP_OUTPUT_NAME} 2>&1
			mv ${TMP_DIR}/${TMP_FILE_NAME} ${DONE_DIR}/
			mv ${TMP_DIR}/${TMP_OUTPUT_NAME} ${OUT_DIR}/
			if $SENDMAIL; then
				cat ${OUT_DIR}/${TMP_OUTPUT_NAME} | mail -s "[dbssh] File $FILE launched at $DATE $TIME" $MAIL
			fi
		fi
	done
	sleep $TIMEOUT
done