defmodule ContactServer.ContactStore do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

	def create(name, contact) do
    GenServer.call(name, {:create, contact})
  end

	def get_all(name) do
    GenServer.call(name, {:get_all})
  end

  ## Server callbacks

  @impl true
  def init(table) do
    contacts = :ets.new(table, [:set, :named_table, keypos: 2, read_concurrency: true])
    {:ok, contacts}
  end

  def handle_call({:create, contact}, _from, contacts) do
		:ets.insert(contacts, contact)
    {:reply, {:ok}, contacts}
  end

  @impl true
  def handle_call({:get_all}, _from, contacts) do
		results = :ets.tab2list(contacts)
    {:reply, {:ok, results}, contacts}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
