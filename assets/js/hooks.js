export let hooks = {};

// Chart.js functionality
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

// Transaction filters storage functionality
hooks.TransactionFilters = {
  mounted() {
    console.log("TransactionFilters hook mounted");
    
    // Listen for events to save filters
    this.handleEvent("save-filters-to-storage", (filters) => {
      console.log("Saving filters to localStorage", filters);
      localStorage.setItem('transaction-filters', JSON.stringify(filters));
    });
    
    // Listen for events to clear filters
    this.handleEvent("clear-filters-from-storage", () => {
      console.log("Clearing filters from localStorage");
      localStorage.removeItem('transaction-filters');
    });
    
    // Wait a short moment to ensure LiveView is fully initialized
    setTimeout(() => {
      // Load filters from localStorage
      const storedFilters = localStorage.getItem('transaction-filters');
      if (storedFilters) {
        console.log("Found stored filters, loading", JSON.parse(storedFilters));
        this.pushEvent("filters-loaded", storedFilters);
      }
    }, 300);
  },
  
  // Handle updates to the element
  updated() {
    console.log("TransactionFilters hook updated");
  }
};
