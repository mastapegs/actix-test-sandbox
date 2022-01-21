FROM rust:latest as build

# create a new empty shell project
RUN USER=root cargo new --bin actix-test-sandbox
WORKDIR /actix-test-sandbox

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/actix_test_sandbox*
RUN cargo build --release

# our final base
FROM rust:slim-buster

# copy the build artifact from the build stage
COPY --from=build /actix-test-sandbox/target/release/actix-test-sandbox .

# set the startup command to run your binary
CMD ["./actix-test-sandbox"]