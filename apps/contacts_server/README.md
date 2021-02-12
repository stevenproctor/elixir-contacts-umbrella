# ContactServer

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `contacts_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:contacts_server, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/contacts_server](https://hexdocs.pm/contacts_server).


## Build and Run

### CLI

To build the CLI
```bash
$ pushd apps/contact_cli
$ mix escript.build
$ popd
```

The CLI takes a number of files and loads them concurrently,
and then will print out the loaded contacts in various sort
orders.

```
$ apps/contact_cli/contact_cli sample_data/gotham.txt
```
