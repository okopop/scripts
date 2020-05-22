#!/bin/bash
# check for wrong file encoding on files in folder. Convert and overwrite wrong ones
# run script with cron
# shellcheck disable=SC2086
FILE_DIR=x
WRONG_ENCODING="UTF-8"
CORRECT_ENCODING="ASCII"
CONVERT_CMD="/usr/bin/iconv"

[ -f $CONVERT_CMD ] || { /bin/logger "[ERROR] Unable to convert file encoding because $CONVERT_CMD is missing"; exit 1; } 

for file in $FILE_DIR/*; do
   CHECK_ENCODING=$(file $FILE_DIR/$file | awk '{print $2}')
   if [ $CHECK_ENCODING == $WRONG_ENCODING ]; then
       echo "$FILE_DIR/$file is in wrong file type: $WRONG_ENCODING"
       /bin/logger "[INFO] $FILE_DIR/$file has encoding $WRONG_ENCODING which is wrong. Converting to $CORRECT_ENCODING"
       # create tmp file with correct file encoding
       # /usr/bin/iconv -f UTF-8 -t ASCII//TRANSLIT file > file.tmp
       $CONVERT_CMD -f $WRONG_ENCODING -t $CORRECT_ENCODING//TRANSLIT $FILE_DIR/$file > $FILE_DIR/$file.tmp
       if [ -s $FILE_DIR/$file.tmp ]; then
           # overwrite original file with tmp file
           mv $FILE_DIR/$file.tmp $FILE_DIR/$file
       else
           echo "[ERROR] $FILE_DIR/$file.tmp is empty or missing... abort overwrite of original file"
           if [ -f $FILE_DIR/$file.tmp ]; then /usr/bin/rm $FILE_DIR/$file.tmp; fi 
           exit 1
       fi
   else
       echo "$file has encoding $CORRECT_ENCODING which is correct"
   fi
done
exit 0
