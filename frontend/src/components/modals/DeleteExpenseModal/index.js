import React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContentText from '@mui/material/DialogContentText';

export default function DeleteExpenseModal(props) {

  const { modal, toggle, method, focusItem } = props;

  const handleSubmit = async () => {
    toggle();
  };

  const handleOnDelete = async () => {
    method({expense_id: focusItem.expense_id})
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
            {"Confirm Expense Deletion"}
        </DialogTitle>
        <DialogContent>
          <DialogContentText>
            This action cannot be undone. Are you sure you would like to delete this expense?
          </DialogContentText>
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Cancel</Button>
            <Button onClick={handleOnDelete} autoFocus style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Confirm</Button>
      </DialogActions>
    </Dialog>
  );
}
