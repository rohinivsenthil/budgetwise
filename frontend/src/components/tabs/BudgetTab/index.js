import React from "react";
import BudgetPieChart from '../../charts/BudgetPieChart';
import Button from '@mui/material/Button';
import EditIcon from '@mui/icons-material/Edit';
import './index.css'

export default function BudgetTab(props) {
    const {budgets} = props;
    const budget = budgets[0]
    return (
        <div className="dashTabContainer">
            <div className="listContainer">
            <div className="chart3">
                <div className="budgetDisplay">Current Budget:</div>
                <div className="budgetValue">{`$${budget.amount}`}</div>
                <Button style={{backgroundColor: '#5753C9', color: 'white', fontSize: 'x-small', width: '40%', fontWeight: 'bold', marginTop: '5rem', marginLeft: '2rem'}} startIcon={<EditIcon/>}>Update Budget</Button>
            </div>
                <div className="chart1"><BudgetPieChart budget={budget}/></div>
            </div>
        </div>
    )
}