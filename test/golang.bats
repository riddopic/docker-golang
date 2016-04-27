#!/usr/bin/env bats

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
