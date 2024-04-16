import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const ForecastChart = ({ forecast }) => {
  const data = forecast["data"]
  if(data!=null){
    const label = data["label"]
    const amount = data["amount"]
    const forecastData = data["forecast"]

    // Highcharts options object
    const options = {
      chart: {
        type: 'column',
        height: 370
      },
      title: {
        text: 'Monthly Forecast',
        style: {
          fontSize: '14px',
          color: '#465098',
        }
      },
      xAxis: {
        categories: label, // Using label data for xAxis categories
        title: {
          text: 'Months'
        }
      },
      yAxis: {
        title: {
          text: 'Amount'
        }
      },
      plotOptions: {
        column: {
          dataLabels: {
            enabled: true
          }
        }
      },
      series: [{
        name: 'Amount',
        data: amount,
        color: '#6E7FF3'
      }, {
        name: 'Forecast Line',
        type: 'line',
        data: forecastData,
        color: '#F9A52B'
      }]
    };
    

  // Rendering the HighchartsReact component with updated options
  return <HighchartsReact highcharts={Highcharts} options={options} />;
  }
};

export default ForecastChart;