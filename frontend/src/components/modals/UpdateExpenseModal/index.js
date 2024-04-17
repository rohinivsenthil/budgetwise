import React, { useEffect, useState } from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import MenuItem from '@mui/material/MenuItem';
import { categories } from '../../../constants';

export default function UpdateExpenseModal(props) {
  const { modal, toggle, focusItem, method } = props;

  // State variables to store values from text fields
  const [expenseName, setExpenseName] = useState(focusItem.name || '');
  const [expenseCategory, setExpenseCategory] = useState(focusItem.category || '');
  const [expenseAmount, setExpenseAmount] = useState(focusItem.amount || '');

  useEffect(() => {
    setExpenseName(focusItem.name)
    setExpenseCategory(focusItem.category)
    setExpenseAmount(focusItem.amount)
  }, [focusItem]);

  const handleSubmit = async () => {
    toggle();
  };

  const handleOnUpdate = async () => {
    const updatedExpense = {
      expense_id: focusItem.expense_id,
      name: expenseName,
      category: expenseCategory,
      amount: expenseAmount,
      date: focusItem.date,
      timestamp: focusItem.timestamp,
    };
    method(updatedExpense);
    toggle();
  };

  return (
    <Dialog
      open={modal}
      onClose={toggle}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title" fontSize="medium">
        {"Update your expense details"}
      </DialogTitle>
      <DialogContent>
        <TextField
          id="standard-start-adornment"
          sx={{ m: 1, width: '40%' }}
          variant="standard"
          helperText="Expense Name"
          value={expenseName}
          onChange={(e) => setExpenseName(e.target.value)}
        />
        <TextField
          id="standard-select-category"
          select
          sx={{ m: 1, width: '40%' }}
          variant="standard"
          helperText="Expense Category"
          value={expenseCategory}
          onChange={(e) => setExpenseCategory(e.target.value)}
        >
          {categories.map((option) => (
            <MenuItem key={option.value} value={option.value}>
              {option.label}
            </MenuItem>
          ))}
        </TextField>
        <TextField
          helperText="Amount"
          id="filled-start-adornment"
          sx={{ m: 1, width: '25ch' }}
          InputProps={{
            startAdornment: <InputAdornment position="start">$</InputAdornment>,
          }}
          variant="standard"
          value={expenseAmount}
          onChange={(e) => setExpenseAmount(parseFloat(e.target.value))}
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={handleSubmit} style={{ color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold' }}>Cancel</Button>
        <Button onClick={handleOnUpdate} autoFocus style={{ color: '#465098', width: '20%', fontSize: 'small', fontWeight: 'bold' }}>Update</Button>
      </DialogActions>
    </Dialog>
  );
}
