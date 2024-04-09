import React from "react";
import './index.css'
import ExpenseList from '../ExpenseList'
import BarChart from '../BudgetChart'

export default function DashboardTab(props) {
    const {deleteExpenseToggle, updateExpenseToggle, setFocusItem, expenses} = props;
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"><ExpenseList deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem} expenses={expenses}/></div>
                <div className="chart1"><BarChart/></div>
            </div>
            <div className="chart2"> Chart 2</div>
        </div>
    );
}