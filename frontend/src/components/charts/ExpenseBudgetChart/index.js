import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';


const ExpenseBudgetChart = (props) => {
  const {budgets, expenses} = props;
  const budget = budgets[0]

  const budgetCategories = JSON.parse(budget.categories);
  for (let category in budgetCategories) {
      budgetCategories[category.charAt(0).toUpperCase() + category.slice(1)] = budgetCategories[category];
      delete budgetCategories[category];
  }

  // Initialize data arrays for 'Actual' and 'Budget' series
  const actualData = [];
  const budgetData = [];

  // Initialize category order
  const categoriesOrder = Object.keys(budgetCategories);

  // Initialize total amount spent for each category
  const totalSpentByCategory = Object.fromEntries(categoriesOrder.map(category => [category, 0]));

  // Calculate total spent for each category
  expenses.forEach(expense => {
      totalSpentByCategory[expense.category] += expense.amount;
  });

  // Populate data arrays for 'Actual' and 'Budget' series
  categoriesOrder.forEach(category => {
      actualData.push(totalSpentByCategory[category]);
      budgetData.push(budgetCategories[category]);
  });

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
    subtitle: {
      text: 'Data Synced with AWS',
      style: {
      fontSize: '9px',
      color: '#999999',
      }
    },
    xAxis: {
      categories: ['Food', 'Groceries', 'Other', 'Utilities']
    },
    yAxis: {
      title: {
        text: 'Amount'
      }
    },
    series: [{
      name: 'Actual',
      data: actualData,
      color: '#CAD0FB',
    }, {
      name: 'Budget',
      data: budgetData,
      color: '#6E7FF3'
    }]
  };

  return (
    <HighchartsReact highcharts={Highcharts} options={options} />
  );
}

export default ExpenseBudgetChart;