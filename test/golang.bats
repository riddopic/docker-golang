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

@test "It should use Go $GOLANG_VERSION" {
  run docker run $IMG bash -c "go version | grep $GOLANG_VERSION"
  [ $status -eq 0 ]
}

@test "It should download Go code" {
  run docker run $IMG bash -c "go get github.com/hoisie/mustache"
  [ $status -eq 0 ]
}

@test "It should build Go code" {
  run docker run $IMG bash -c "go get github.com/deis/example-go && go build github.com/deis/example-go"
  [ $status -eq 0 ]
}

@test "It should test Go code" {
  run docker run $IMG bash -c "go get github.com/hoisie/mustache && go test github.com/hoisie/mustache"
  [ $status -eq 0 ]
}
