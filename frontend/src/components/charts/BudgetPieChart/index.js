import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const colors = ['#6E7FF3', '#8B91F7', '#A9ADEF', '#C7CAF2'];

const options = {
  chart: {
    type: 'pie',
    height: 350
  },
  title: {
    text: 'Budget Breakdown',
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
      { name: 'Food', y: 100, color: colors[0] },
      { name: 'Groceries', y: 100, color: colors[1] },
      { name: 'Utilities', y: 100, color: colors[2] },
      { name: 'Other', y: 200, color: colors[3] }
    ],
    dataLabels: {
      enabled: true,
      // eslint-disable-next-line no-template-curly-in-string
      format: '<b>{point.name}</b>: ${point.y}',
    }
  }]
};

const BudgetPieChart = () => <HighchartsReact highcharts={Highcharts} options={options} />;

export default BudgetPieChart;