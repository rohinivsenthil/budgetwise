import React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import MenuItem from '@mui/material/MenuItem';
import {categories} from '../../../constants'

export default function UpdateExpenseModal(props) {

  const { modal, toggle, focusItem, method } = props;

  const handleSubmit = async () => {
    toggle();
  };

  const handleOnUpdate = async () => {
    method({})
    toggle();
  }

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
                defaultValue={focusItem.name}
            />
            <TextField
                id="standard-select-category"
                select
                sx={{ m: 1, width: '40%' }}
                variant='standard'
                helperText="Expense Category"
                defaultValue={focusItem.category !== undefined ? focusItem.category : ''}
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
                defaultValue={focusItem.amount}
            />
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Cancel</Button>
            <Button onClick={handleOnUpdate} autoFocus style={{color: '#465098', width: '20%', fontSize: 'small', fontWeight: 'bold'}}>Update</Button>
      </DialogActions>
    </Dialog>
  );
}
