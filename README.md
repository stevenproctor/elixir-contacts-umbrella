# ContactsUmbrella


## Contact Server (contacts_server)

The contact server is the BEAM application (think library in
other platforms) that handles the logic for:
 - parsing a line into a Contact Map
 - storing that Contact Map into ETS
 - fetching the records from ETS
 - sorting a list of Contact Maps

This is an application, with a supervised process
that owns an ETS table for storage.

The ETS table is a set, where the whole Contact Map
is the key, so any duplicates will be ignored.

It was not an ordered set, there was no unique key,
but just the whole object, so didn't think making it ordered
would get much benefit.

## CLI (contacts_cli)

### Build and Run

#### Building

To build the CLI
```bash
$ pushd apps/contact_cli
$ mix escript.build
$ popd
```

#### Running

The CLI takes a number of files and loads them concurrently,
and then will print out the loaded contacts in various sort
orders.

```
$ apps/contact_cli/contact_cli sample_data/gotham.txt
```

### File Loading design

For each file to load, a new Task is kicked off to have the
loading of the contacts from each file take place in an isolated
process.

This buys two things:

First, it speeds up importing the contacts to only wait for
the longest file to process, via a parallel fork/join model.

Second, it gives process isolation, so that if one of
the processes dies the rest of the files can be loaded and run
with the results from the file loads that didn't crash.

## Web app (contacts_web)

To start the web app run

```
$ mix phx.server
```

When hitting the endpoints `records/name`, `records/email`, or `records/birthdate`,
the contacts listing will be empty on first start as there have been
no records added to the ContactStore since a POST request to `records`
has not been made.

