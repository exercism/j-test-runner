.PHONY : build-image run-example clean really-clean

IMAGE:= exercism/j-test-runner
INDIR:= /opt/test-runner/test/arith-pass/
OUTDIR:= /opt/test-runner/
SLUG:= arithmetic

build-image :
	docker build -t $(IMAGE) .

run-example : build-image
	docker run -it $(IMAGE) ./bin/run.sh $(SLUG) $(INDIR) $(OUTDIR)

clean :
	find . -name "*~" -exec rm {} \;

really-clean : clean
	docker image rm --force $(IMAGE)
