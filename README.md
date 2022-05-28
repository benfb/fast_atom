<p align="center"> <img alt="FastRSS" src="https://avencera.github.io/fast_rss/logo.svg"> </p>
<p align="center">Parse RSS feeds very quickly </p>
<p align="center">
    <a href="https://hex.pm/packages/fast_rss"><img alt="Hex.pm" src="https://img.shields.io/hexpm/l/fast_rss"></a>
    <a href="https://hex.pm/packages/fast_rss"><img alt="Hex.pm" src="https://img.shields.io/hexpm/v/fast_rss"></a>
    <a href="https://hex.pm/packages/fast_rss"><img alt="Hex.pm" src="https://img.shields.io/hexpm/dt/fast_rss"></a>
    <a href="https://hexdocs.pm/fast_rss"><img alt="HexDocs.pm" src="https://img.shields.io/badge/hex-docs-purple.svg"></a>
    <a href="https://github.com/avencera/fast_rss/commits/master"><img alt="last commit" src="https://img.shields.io/github/last-commit/avencera/fast_rss.svg"></a>
</p>

<p align="center">
  <a href="#intro">Intro</a>
  |
  <a href="#compatibility">Compatibility</a>
  |
  <a href="#installation">Installation</a>
  |
  <a href="#usage">Usage</a>
  |
  <a href="#benchmark">Benchmarks</a>
  |
  <a href="#deploying">Deploying</a>
  |
  <a href="LICENSE">License</a>
</p>

---

## Intro

Parse RSS feeds very quickly

- This is rust NIF built using [rustler](https://github.com/rusterlium/rustler)
- Uses the [RSS](https://crates.io/crates/rss) rust crate to do the actual RSS parsing

## Compatibility

FastAtom requires a minimum combination of Elixir 1.6.0 and Erlang/OTP 20.0, and is tested with a maximum combination of Elixir 1.11.1 and Erlang/OTP 22.0.

## Installation

This package is available on [hex](https://hex.pm/packages/fast_rss).

It can be installed by adding `fast_rss` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fast_rss, "~> 0.3.4"}
  ]
end
```

You also need the rust compiler installed: https://www.rust-lang.org/tools/install

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Usage

There is only one function it takes an RSS string and outputs an `{:ok, map()}` with string keys.

```elixir
iex(1)>  {:ok, map_of_rss} = FastAtom.parse("...atom_feed_string...")
iex(2)> Map.keys(map_of_rss)
["categories", "cloud", "copyright", "description", "docs", "dublin_core_ext",
 "extensions", "generator", "image", "items", "itunes_ext", "language",
 "last_build_date", "link", "managing_editor", "namespaces", "pub_date",
 "rating", "skip_days", "skip_hours", "syndication_ext", "text_input", "title",
 "ttl", "webmaster"]
```

The docs can be found at [https://hexdocs.pm/fast_rss](https://hexdocs.pm/fast_atom).

### Supported Feeds

Reading from the following RSS versions is supported:

- RSS 0.90
- RSS 0.91
- RSS 0.92
- RSS 1.0
- RSS 2.0
- iTunes
- Dublin Core

## Deploying

Deploying rust NIFs can be a little bit annoying as you have to install the rust compiler. If you are having trouble deploying this package make an issue and I will try and help you out.

I will then add it to the FAQ below.

### Q. How do I deploy using an Alpine Dockerfile?

#### A. I recommend using a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/), and doing the following

1.  On the stages where you build all your deps, and build your release make sure to install `build-base` and `libgcc`:

    ```dockerfile
    # This step installs all the build tools we'll need
    RUN apk update && \
        apk upgrade --no-cache && \
        apk add --no-cache \
        git \
        curl \
        build-base \
        libgcc  && \
        mix local.rebar --force && \
        mix local.hex --force
    ```

2.  Install the rust compiler and allow dynamic linking to the C library by setting the rust flag

    ```dockerfile
    # install rustup
    RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    ENV RUSTUP_HOME=/root/.rustup \
        RUSTFLAGS="-C target-feature=-crt-static" \
        CARGO_HOME=/root/.cargo  \
        PATH="/root/.cargo/bin:$PATH"
    ```

3.  On the stage where you actually run your elixir release install `libgcc`:

    ```dockerfile
    ################################################################################
    ## STEP 4 - FINAL
    FROM alpine:3.11

    ENV MIX_ENV=prod

    RUN apk update && \
        apk add --no-cache \
        bash \
        libgcc \
        openssl-dev

    COPY --from=release-builder /opt/built /app
    WORKDIR /app
    CMD ["/app/my_app/bin/my_app", "start"]
    ```

## License

FastRSS is released under the Apache License 2.0 - see the [LICENSE](LICENSE) file.
