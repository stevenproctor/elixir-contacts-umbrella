# ContactsUmbrella

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

### Web app

To start the web app run

```
$ mix phx.server
```

