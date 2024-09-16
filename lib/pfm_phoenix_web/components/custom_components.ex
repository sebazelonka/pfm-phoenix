# create a compotent to display a pie chart using chart.js
defmodule PfmPhoenixWeb.CustomComponents do
  use Phoenix.Component

  def customChart(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center w-full">
      <canvas id="myChart" phx-hook="ChartJS" class="w-96 h-96" data-graph={@graph}></canvas>
    </div>
    """
  end
end
