import Chart from "chart.js/auto";

export let hooks = {};
hooks.ChartJS = {
  mounted() {
    const ctx = this.el;
    const data = {
      type: "pie",
      data: {
        // random data to validate chart generation
        labels: ["Red", "Blue", "Yellow"],
        datasets: [{ data: [300, 50, 100] }],
      },
    };

    new Chart(ctx, data);
  },
};
