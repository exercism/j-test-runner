.PHONY : build-image run-example clean really-clean

IMAGE:= exercism/j-test-runner
INDIR:= /opt/test-runner/test/nc-pass/
OUTDIR:= /opt/test-runner/
SLUG:= nucleotide-count

build-image : clean
	docker build -t $(IMAGE) .

run-example : build-image
	docker run -it $(IMAGE) ./bin/run.sh $(SLUG) $(INDIR) $(OUTDIR)

clean :
	find . -name "*~" -exec rm {} \;

cleaner : clean
	docker image rm --force $(IMAGE)
