import React from "react";
import {data} from '../../constants'
import './index.css'
import IconButton from '@mui/material/IconButton';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';

export default function ExpenseList(props) {
    const {deleteExpenseToggle, updateExpenseToggle, setFocusItem} = props;
    const onUpdate = (item) => {
        setFocusItem(item);
        updateExpenseToggle();
    }
    return (
        <div className="table">
            <div className="tableTitle">Expense History</div>
            <div className="tableHeading">
                <div className="tableHeadingContent">Date</div>
                <div className="tableHeadingContent">Name</div>
                <div className="tableHeadingContent">Category</div>
                <div className="tableHeadingContent">Amount</div>
                <div className="tableHeadingContent">Actions</div>
            </div>
            {data.map((item) => (
                <div className="tableData">
                    <div className="tableDataContent">{item.date}</div>
                    <div className="tableDataContent">{item.name}</div>
                    <div className="tableDataContent">
                        <div className={`tableDataCategory-${item.category}`}>{item.category}</div>
                    </div>
                    <div className="tableDataContent">${item.amount}</div>
                    <div className="tableActions">
                        <IconButton aria-label="edit" style={{padding: 0}} onClick={() => onUpdate(item)}>
                            <EditIcon fontSize="small"/>
                        </IconButton>
                        <IconButton aria-label="delete" style={{padding: 0, marginLeft: '.5rem'}} onClick={deleteExpenseToggle}>
                            <DeleteIcon fontSize="small"/>
                        </IconButton>
                    </div>
                </div>
            ))}

        </div>);
}