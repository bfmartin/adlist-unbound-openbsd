# handle some housekeeping tasks

# count these files
FILES = bin/*

# show any todo's and fixme's
notes:
	@find ./* -type f -exec grep -En '(FIXME|TODO|XXX|THINKME):' {} /dev/null \;
	@cat TODO.md

# outputs date, line-count, file-count, average-lines-per-file
# ignore blank lines and comments
count:
	@FCOUNT=$$(ls ${FILES} | wc -l) && \
		LCOUNT=$$(cat ${FILES} | sed "s/#.*//" | awk NF | wc -l) && \
		AVG=$$(echo "scale=1;$$LCOUNT/$$FCOUNT" | bc -l) && \
		echo $$(date +%Y-%m-%d), "$$LCOUNT", "$$FCOUNT", "$$AVG"
