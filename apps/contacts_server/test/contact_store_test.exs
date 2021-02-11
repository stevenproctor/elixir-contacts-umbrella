defmodule ContactServer.ContactStoreTest do
  use ExUnit.Case, async: true

  setup context do
    _ = start_supervised!({ContactServer.ContactStore, context.test})
    %{store: context.test}
  end

  test "adding a contact puts the contact in the store", %{store: store} do
    contact = {"a", "b", "c", "d", ~D[2020-01-01]}
    ContactServer.ContactStore.create(store, contact)
    {:ok, contacts} = ContactServer.ContactStore.get_all(store)
    assert list_contains(contacts, contact)
  end

  test "adding the same contact multiple times only puts the contact in the store once", %{store: store} do
    contact = {"a", "b", "c", "d", ~D[2020-01-01]}
    ContactServer.ContactStore.create(store, contact)
    ContactServer.ContactStore.create(store, contact)
    {:ok, contacts} = ContactServer.ContactStore.get_all(store)
    assert length(contacts) == 1
  end

  test "adding the two contacts differing by date adds both contacts", %{store: store} do
    contact1 = {"a", "b", "c", "d", ~D[2020-01-01]}
    contact2 = {"a", "b", "c", "d", ~D[1920-01-01]}
    ContactServer.ContactStore.create(store, contact1)
    ContactServer.ContactStore.create(store, contact2)
    {:ok, contacts} = ContactServer.ContactStore.get_all(store)
    assert length(contacts) == 2
  end

  defp list_contains([], _) do
    false
  end
  defp list_contains([x|_], x) do
    true
  end
  defp list_contains([_|rest], x) do
    list_contains(x, rest)
  end
end
