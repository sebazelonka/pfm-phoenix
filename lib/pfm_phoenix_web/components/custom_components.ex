# create a compotent to display a pie chart using chart.js
defmodule PfmPhoenixWeb.CustomComponents do
  use Phoenix.Component

  attr :values, :list, required: true
  attr :categories, :list, required: true

  def customChart(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center w-full">
      <canvas
        id="myChart"
        phx-hook="ChartJS"
        class="w-96 h-96"
        data-graph-values={Enum.join(@values, ",")}
        data-graph-categories={Enum.join(@categories, ",")}
      >
      </canvas>
    </div>
    """
  end
end
