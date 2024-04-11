import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const colors = ['#f2eb9e', '#D0F0C0', '#B9D9EB', '#D8BFD8'];

const options = {
  chart: {
    type: 'pie',
    height: 350
  },
  title: {
    text: 'Monthly Expense Breakdown',
    style: {
        fontSize: '14px',
        color: '#465098',
      }
  },
  subtitle: {
    text: 'Data Synced with AWS',
    style: {
    fontSize: '9px',
    color: '#999999',
    }
  },
  tooltip: {
    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
  },
  series: [{
    name: 'Expenses',
    data: [
      { name: 'Food', y: 57, color: colors[0] },
      { name: 'Groceries', y: 23.5, color: colors[1] },
      { name: 'Utilities', y: 34, color: colors[2] },
      { name: 'Other', y: 8, color: colors[3] }
    ],
    dataLabels: {
      enabled: true,
      // eslint-disable-next-line no-template-curly-in-string
      format: '<b>{point.name}</b>: ${point.y}',
    }
  }]
};

const ExpensePieChart = () => <HighchartsReact highcharts={Highcharts} options={options} />;

export default ExpensePieChart;