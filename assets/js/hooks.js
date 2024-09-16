export let hooks = {};
hooks.ChartJS = {
  mounted() {
    const ctx = this.el.getContext("2d");

    // Parse the JSON string into an object
    const graphData = JSON.parse(this.el.dataset.graph);

    // Use graphData to render your chart with Chart.js
    const config = {
      type: "pie",
      data: {
        labels: graphData.map((item) => item.label),
        datasets: [{ data: graphData.map((item) => item.value) }],
      },
    };

    new Chart(ctx, config);
  },
};
