all:
	gem which storazzo
	bundle exec gem which storazzo

ricdisk-magic-local: all
	bundle exec bin/ricdisk-magic .

watch-ricdisk-magic-local: all
	watch bundle exec bin/ricdisk-magic .

watch-ricdisk-magic-local-etc-readonly: all
	watch bundle exec bin/ricdisk-magic /etc///
