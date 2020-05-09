#!/usr/bin/env bash

JOURNAL=$1_Journal_Current.markdown
FIRSTLINE=${@:2}

echo -e "# $(date)\n\n$FIRSTLINE\n\n$(cat modelines_for_journals)" > $JOURNAL
