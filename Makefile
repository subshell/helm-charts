chart_dir =
chart_file = $(chart_dir)/Chart.yaml
test_file = $(chart_dir)/test-values.yaml

test:
ifneq ("$(wildcard $(test_file))","")
	echo "test"
	helm template -f "$(test_file)" test "$(chart_dir)" --output-dir /tmp
endif

build: test
ifneq ("$(wildcard $(chart_file))","")
	echo "build"
	helm package "$(chart_dir)" --destination out
endif

push: build push_only
	echo "push"

push_only:
ifneq ("$(wildcard $(chart_file))","")
	helm push "$(chart_dir)" sophora
endif
