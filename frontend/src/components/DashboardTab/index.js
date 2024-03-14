import React from "react";
import './index.css'
import ExpenseList from '../ExpenseList'

export default function DashboardTab() {
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"><ExpenseList/></div>
                <div className="chart1">Chart 1</div>
            </div>
            <div className="chart2"> Chart 2</div>
        </div>
    );
}