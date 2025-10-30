import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "chartOutput" ]

  connect() {
    this.fetchConsumptionData()
  }

  async fetchConsumptionData() {
    try {
      const response = await fetch('/consumptions', {
        headers: {
          'Accept': 'application/json'
        }
      })
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      const data = await response.json()
      this.renderChart(data.monthly_total_consumption)
    } catch (error) {
      console.error('Error fetching consumption data:', error)
    }
  }

  renderChart(monthlyTotals) {
    if (this.chart) {
      this.chart.destroy()
    }

    if (Object.keys(monthlyTotals).length === 0) {
      console.warn("No monthly consumption data available.")
      return
    }

    const labels = Object.keys(monthlyTotals)
    const totalDataValues = Object.values(monthlyTotals)

    const ctx = this.chartOutputTarget.getContext('2d')
    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Monthly Total Consumption',
            data: totalDataValues,
          }
        ]
      }
    })
  }
}
