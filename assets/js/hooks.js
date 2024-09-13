export let hooks = {};
hooks.ChartJS = {
  mounted() {
    const ctx = this.el.getContext("2d");
    const dataValues = this.el.dataset.graphValues.split(",");
    // .map((elem) => parseInt(elem, 10));

    const dataCategories = this.el.dataset.graphCategories.split(",");
    // const dataGraph = this.el.dataset.graphData.split(",");

    // console.log(dataGraph);

    console.log(dataValues);

    const config = {
      type: "pie",
      data: {
        // random data to validate chart generation
        labels: dataCategories,
        datasets: [{ data: dataValues }],
      },
    };

    new Chart(ctx, config);
  },
};
