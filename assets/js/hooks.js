export let hooks = {};
hooks.ChartJS = {
  mounted() {
    const ctx = this.el.getContext("2d");
    console.log(ctx);

    const config = {
      type: "pie",
      data: {
        // random data to validate chart generation
        labels: ["Red", "Blue", "Yellow"],
        datasets: [{ data: [300, 50, 100] }],
      },
    };

    new Chart(ctx, config);
  },
};
