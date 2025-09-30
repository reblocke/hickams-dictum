# Minimal makefile to run the analysis
# Usage:
#   make run                  # uses STATA variable or tries 'stata-mp'
#   make clean

STATA ?= stata-mp

run:
	$(STATA) -b do "Hickam Analysis.do"

clean:
	@echo "Removing generated results (keep with care)"
	@rm -rf "Results and Figures"
