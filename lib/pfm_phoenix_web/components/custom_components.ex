# create a compotent to display a pie chart using chart.js
defmodule PfmPhoenixWeb.CustomComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import PfmPhoenixWeb.CoreComponents
  import PfmPhoenixWeb.Gettext

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def customChart(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <canvas id="myChart" width="400" height="400" phx-hook="ChartJS"></canvas>
    </div>
    <div class="flex flex-row justify-center gap-4">
      <.button phx-click="change-data" phx-value-set="1">SET 1</.button>
      <.button phx-click="change-data" phx-value-set="2">SET 2</.button>
      <.button phx-click="change-data" phx-value-set="3">SET 3</.button>
    </div>
    """
  end
end
