defmodule Pourover.Brew do
  # loads human friendly names for beans, grinder, brewer, and filter
  # TODO: format timestamp more nicely
  def denormalize(brew, lookups) do
    brew
    |> Map.update(:beans, "missing", &beans_display_name(&1, lookups.beans))
    |> Map.update(:grinder, "missing", &grinder_name(&1, lookups.grinders))
    |> Map.update(:brewer, "missing", &brewer_name(&1, lookups.brewers))
    |> Map.update(:filter, "missing", &filter_name(&1, lookups.filters))
  end

  defp beans_display_name(bean_id, beans) do
    beans
    |> Enum.find(&(&1.id == bean_id))
    |> then(& &1.display_name)
  end

  defp grinder_name(grinder_id, grinders) do
    grinders
    |> Enum.find(&(&1.id == grinder_id))
    |> then(& &1.name)
  end

  defp brewer_name(brewer_id, brewers) do
    brewers
    |> Enum.find(&(&1.id == brewer_id))
    |> then(& &1.name)
  end

  defp filter_name(filter_id, filters) do
    filters
    |> Enum.find(&(&1.id == filter_id))
    |> then(& &1.name)
  end
end
