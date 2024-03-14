import React from "react";
import {data} from '../../constants'
import './index.css'

export default function ExpenseList() {
    return (
        <div className="table">
            <div className="tableTitle">Expense History</div>
            <div className="tableHeading">
                <div className="tableHeadingContent">Date</div>
                <div className="tableHeadingContent">Name</div>
                <div className="tableHeadingContent">Category</div>
                <div className="tableHeadingContent">Amount</div>
            </div>
            {data.map((item) => (
                <div className="tableData">
                    <div className="tableDataContent">{item.date}</div>
                    <div className="tableDataContent">{item.name}</div>
                    <div className="tableDataContent">
                        <div className={`tableDataCategory-${item.category}`}>{item.category}</div>
                    </div>
                    <div className="tableDataContent">${item.amount}</div>
                </div>
            ))}

        </div>);
}