import React from "react";
import './index.css'
import ExpenseList from '../ExpenseList'

export default function DashboardTab(props) {
    const {deleteExpenseToggle, updateExpenseToggle, setFocusItem} = props;
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"><ExpenseList deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem}/></div>
                <div className="chart1">Chart 1</div>
            </div>
            <div className="chart2"> Chart 2</div>
        </div>
    );
}