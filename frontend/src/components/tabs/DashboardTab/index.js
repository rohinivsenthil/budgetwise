import React from "react";
import './index.css'
import ExpenseList from '../../ExpenseList'
import ExpenseBudgetChart from '../../charts/ExpenseBudgetChart'
import ExpensePieChart from "../../charts/ExpensePieChart";
import ForecastChart from "../../charts/ForecastChart";

export default function DashboardTab(props) {
    const {deleteExpenseToggle, updateExpenseToggle, setFocusItem, expenses, budgets, forecast} = props;
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"><ExpenseList deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem} expenses={expenses}/></div>
                <div className="chart1"><ExpenseBudgetChart budgets={budgets} expenses={expenses}/></div>
            </div>
            <div className="listContainer">
                <div className="chart2"><ExpensePieChart expenses={expenses}/></div>
                <div className="chart1"><ForecastChart forecast={forecast}/></div>
            </div>
        </div>
    );
}