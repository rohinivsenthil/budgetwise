import React from "react";
import './index.css'
import ExpenseList from '../../ExpenseList'
import BarChart from '../../charts/ExpenseBudgetChart'
import ExpensePieChart from "../../charts/ExpensePieChart";
import ForecastChart from "../../charts/ForecastChart";

export default function DashboardTab(props) {
    const {deleteExpenseToggle, updateExpenseToggle, setFocusItem, expenses} = props;
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"><ExpenseList deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem} expenses={expenses}/></div>
                <div className="chart1"><BarChart/></div>
            </div>
            <div className="listContainer">
                <div className="chart2"><ExpensePieChart/></div>
                <div className="chart1"><ForecastChart/></div>
            </div>
        </div>
    );
}