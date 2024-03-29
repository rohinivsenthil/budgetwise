import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const options = {
  chart: {
    type: 'bar',
    height: 350
  },
  title: {
    text: 'Monthly Expense vs Budget',
    style: {
        fontSize: '14px',
        color: '#465098',
      }
  },
  xAxis: {
    categories: ['Groceries', 'Food', 'Utilities', 'Other']
  },
  yAxis: {
    title: {
      text: 'Amount'
    }
  },
  series: [{
    name: 'Actual',
    data: [57, 23.5, 34, 8],
    color: '#CAD0FB'
  }, {
    name: 'Budget',
    data: [100, 100, 100, 200],
    color: '#6E7FF3'
  }]
};

const BarChart = () => <HighchartsReact highcharts={Highcharts} options={options} />;

export default BarChart;