#!/usr/bin/env bats

setup() {
  docker history "bluebeluga/alpine:3.2" >/dev/null 2>&1
}

@test "checking image size" {
  MAX_SIZE=20000
  run docker run "bluebeluga/alpine:3.2" bash -c "[[ \"\$(du -d0 / 2>/dev/null | awk '{print \$1; print > \"/dev/stderr\"}')\" -lt \"$MAX_SIZE\" ]]"
  [ $status -eq 0 ]
}

@test "It should use Go ${GOLANG_VERSION}" {
  go_version_string="$(echo "go${GOLANG_VERSION}")"
  go version | grep "${go_version_string}"
}

@test "It should download Go code" {
  go get -d github.com/hoisie/mustache
}

@test "It should test Go code" {
  go test github.com/hoisie/mustache
}

@test "It should build Go code" {
  go get github.com/deis/example-go
  go build github.com/deis/example-go
}

@test "It should generate a Go executable" {
  [[ -x ${GOPATH}/bin/example-go ]]
}
