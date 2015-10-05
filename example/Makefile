SUBDIRS=hello

all:
	@for a in $(SUBDIRS) ; do \
		make -C $(SUBDIRS) all ; \
	done

clean:
	@for a in $(SUBDIRS) ; do \
		make -C $(SUBDIRS) clean ; \
	done
