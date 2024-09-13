# create a compotent to display a pie chart using chart.js
defmodule PfmPhoenixWeb.CustomComponents do
  use Phoenix.Component

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def customChart(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <canvas id="myChart" width="400" height="400" phx-hook="ChartJS"></canvas>
    </div>
    """
  end
end
