import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const colors = ['#f2eb9e', '#D0F0C0', '#B9D9EB', '#D8BFD8'];

const ExpensePieChart = (props) => {
  const {expenses} = props;
  // Initialize an object to store total expenses for each category
  const totalExpensesByCategory = {};

  // Calculate total expenses for each category
  expenses.forEach(expense => {
      if (!totalExpensesByCategory[expense.category]) {
          totalExpensesByCategory[expense.category] = 0;
      }
      totalExpensesByCategory[expense.category] += expense.amount;
  });

  // Prepare data array for the pie chart
  const pieChartData = Object.keys(totalExpensesByCategory).map((category, index) => ({
    name: category,
    y: totalExpensesByCategory[category],
    color: colors[index]
  }));

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
      data: pieChartData,
      dataLabels: {
        enabled: true,
        // eslint-disable-next-line no-template-curly-in-string
        format: '<b>{point.name}</b>: ${point.y:.2f}',
      }
    }]
  };

  return(
    <HighchartsReact highcharts={Highcharts} options={options} />
  );
}

export default ExpensePieChart;