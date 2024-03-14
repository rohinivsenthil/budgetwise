import React from "react";
import './dashtab.css'

export default function DashboardTab() {
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
                <div className="list1"> Expense List</div>
                <div className="chart1">Chart 1</div>
            </div>
            <div className="chart2"> Chart 2</div>
        </div>
    );
}