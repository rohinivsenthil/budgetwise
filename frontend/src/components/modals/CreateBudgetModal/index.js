import React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContentText from '@mui/material/DialogContentText';

export default function CreateBudgetModal(props) {

  const { modal, toggle } = props;

  const handleSubmit = async () => {
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
            {"Create New Budget"}
        </DialogTitle>
        <DialogContent>
          <DialogContentText>
            Seems like you already have a budget created for this account. Please edit the current budget in the "Budget" section instead.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Close</Button>
      </DialogActions>
    </Dialog>
  );
}
