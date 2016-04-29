#!/usr/bin/env bats

setup() {
  docker history "$REGISTRY/$REPOSITORY:$TAG" >/dev/null 2>&1
  export IMG="$REGISTRY/$REPOSITORY:$TAG"
  export GOLANG_VERSION=$GOLANG_VERSION
  export MAX_SIZE=2000000
}

@test "checking image size" {
  run docker run $IMG bash -c "[[ \"\$(du -d0 / 2>/dev/null | awk '{print \$1; print > \"/dev/stderr\"}')\" -lt \"$MAX_SIZE\" ]]"
  [ $status -eq 0 ]
}

@test "It should use Go ${GOLANG_VERSION}" {
  run docker run $IMG go_version_string="$(echo "go${GOLANG_VERSION}")"
  run docker run $IMG go version | grep "${go_version_string}"
}

@test "It should download Go code" {
  run docker run $IMG go get -d github.com/hoisie/mustache
}

@test "It should test Go code" {
  run docker run $IMG go test github.com/hoisie/mustache
}

@test "It should build Go code" {
  run docker run $IMG go get github.com/deis/example-go
  run docker run $IMG go build github.com/deis/example-go
}

@test "It should generate a Go executable" {
  run docker run $IMG bash -c "[[ -x ${GOPATH}/bin/example-go ]]"
}
