#!/usr/bin/env bash
# Purpose: move current journal entry to archive, start new journal entry with defaults.
# Supports specific journals identified with single-word names. If there's no name or 
# the wrong name, script exits with the message "No." Makes use of some external templates
# where identified. Also takes preffered modelines from an external file to avoid editor
# confusion.
#
# Use: sh journal_archive.sh [Journal Name]

JOURNALNAME=$1
CURRENT="$JOURNALNAME"_Journal_Current.markdown
ARCHIVE="$JOURNALNAME"_Journal_Archive.markdown
JOURNALMODELINES=$(cat modelines_for_journals)


case "$JOURNALNAME" in
	"Professional")
		# I have started getting a list of recurrent tasks for my professional journal. This is ugly
		# and complains multiple compromises to mediocrity, including extra blank lines and having
		# to list all tasks on a single line. This gets the day of the week (1-7) and reads the
		# text at that line in the file, appending it to the top of the preserved items below.
		#
		# First sed prints everyting between the two strings below, including the strings.
		# sed -n start_pattern,end_pattern/p
		# Second sed replaces the line below with that line, two newlines, and the recurring
		# task line from the file.
		# https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html
		RECURRING=$(sed -n "$(date +%u)p" Professional_Journal_Recurring_Tasks_Daily)
		DEFAULTENTRY=$(sed -n "/## Things and Stuff/,/## Completed/p" $CURRENT | 
			sed "s/## Things and Stuff/## Things and Stuff\n\n$RECURRING/");;
	"Nethack")
		# I have a standard set of things I want to see in each new Nethack journal
		# page. I keep them stored elsewhere for inclusion here.
		DEFAULTENTRY=$(cat Nethack_Journal_Template.markdown);;
	*) echo "No"; exit ;;
esac

# If the archive doesn't already exist, create it with the preferred modelines at the
# top of the file.
if [ ! -f "$ARCHIVE" ]; then
	echo -e "$JOURNALMODELINES\n\n" > $ARCHIVE
fi

# When the above case is done, get all the lines from the current page EXCEPT the last one,
# which only contains modelines.
head $CURRENT --lines=-1 >> $ARCHIVE

# Then overwrite the existing journal page with a new one starting with the date at headline 1,
# the default entry, and (you guessed it) any modelines we want.
echo -e "# $(date)\n\n$DEFAULTENTRY\n\n\n$JOURNALMODELINES" > $CURRENT

