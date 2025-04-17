/* Local storage handling for transaction filters */

const initTransactionFilters = () => {
  const liveSocket = window.liveSocket;
  
  // Get a reference to the Transaction Index LiveView
  liveSocket.hooks.TransactionFilters = {
    // When the element connects to the DOM
    mounted() {
      // Listen for events to save filters
      this.handleEvent("save-filters-to-storage", (filters) => {
        localStorage.setItem('transaction-filters', JSON.stringify(filters));
      });
      
      // Listen for events to clear filters
      this.handleEvent("clear-filters-from-storage", () => {
        localStorage.removeItem('transaction-filters');
      });
      
      // Listen for events to get filters
      this.handleEvent("get-filters-from-storage", () => {
        const storedFilters = localStorage.getItem('transaction-filters');
        if (storedFilters) {
          this.pushEvent("filters-loaded", storedFilters);
        }
      });
    }
  };
};

// Initialize when the document is loaded
if (typeof window !== "undefined") {
  window.addEventListener("DOMContentLoaded", () => {
    initTransactionFilters();
  });
  
  // Also initialize when phx:page-loading-stop happens
  // This ensures the hooks are registered even on LiveView reconnects
  window.addEventListener("phx:page-loading-stop", () => {
    initTransactionFilters();
  });
}