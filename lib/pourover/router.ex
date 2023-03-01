defmodule Pourover.Router do
  use Plug.Router

  @template_dir "lib/pourover/templates"

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  alias Pourover.Brew

  get "/" do
    render(conn, "index.html", message: nil)
  end

  get "/pourovers" do
    lookups = read_lookups()

    brews =
      read_data("brews.json")
      |> Enum.sort_by(& &1.timestamp, :desc)
      |> Enum.map(&Brew.denormalize(&1, lookups))

    render(conn, "pourovers/index.html", brews: brews)
  end

  get "/pourovers/new" do
    lookups = read_lookups()

    render(conn, "pourovers/new.html",
      beans: lookups.beans,
      grinders: lookups.grinders,
      brewers: lookups.brewers,
      filters: lookups.filters
    )
  end

  get "/pourovers/:id" do
    lookups = read_lookups()

    brew =
      read_data("brews.json")
      |> Enum.find(&(&1.id == id))
      |> Brew.denormalize(lookups)

    render(conn, "pourovers/view.html", brew: brew)
  end

  post "/pourovers" do
    brews =
      case File.read("data/brews.json") do
        {:ok, contents} -> Jason.decode!(contents, keys: :atoms)
        _ -> []
      end

    [add_generated_fields(conn.params) | brews]
    |> Jason.encode!(pretty: true)
    |> then(fn data -> File.write!("data/brews.json", data) end)

    render(conn, "index.html", message: "submission saved!")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp read_data(filename) do
    "data/#{filename}"
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  defp read_lookups() do
    %{}
    |> Map.put(:grinders, read_data("grinders.json"))
    |> Map.put(:beans, read_data("beans.json") |> add_display_name())
    |> Map.put(:brewers, read_data("brewers.json"))
    |> Map.put(:filters, read_data("filters.json"))
  end

  defp render(%{status: status} = conn, template, assigns) do
    body =
      @template_dir
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(assigns)

    send_resp(conn, status || 200, body)
  end

  defp add_generated_fields(brew) do
    brew
    |> add_timestamp()
    |> add_id()
  end

  defp add_timestamp(brew) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()

    Map.put(brew, :timestamp, timestamp)
  end

  defp add_id(brew) do
    Map.put(brew, :id, UUID.uuid4())
  end

  defp add_display_name(beans) do
    beans
    |> Enum.map(fn bean ->
      Map.put(bean, :display_name, "#{bean.roaster} #{bean.name} (#{bean.roast_date})")
    end)
  end
end
