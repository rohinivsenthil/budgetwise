import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

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
    categories: ['February', 'March', 'April', 'May<br/>(Forecasted)'],
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
    data: [100, 100, 50, 75],
    color: '#6E7FF3'
  }, {
    name: 'Forecast Line',
    type: 'line',
    data: [50, 100, 60, 75],
    color: '#F9A52B'
  }]
};

const ForecastChart = () => <HighchartsReact highcharts={Highcharts} options={options} />;

export default ForecastChart;