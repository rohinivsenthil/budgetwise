import React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';

export default function UpdateBudgetModal(props) {

  const { modal, toggle, focusItem, method } = props;
  const budget = focusItem[0]
  const categories = JSON.parse(budget.categories);

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
            {"Update your budget details"}
        </DialogTitle>
        <DialogContent>
            <TextField
                helperText="Total Budget"
                id="filled-start-adornment"
                sx={{ m: 1, width: '25ch' }}
                InputProps={{
                    startAdornment: <InputAdornment position="start">$</InputAdornment>,
                }}
                variant="standard"
                defaultValue={budget.amount}
            />
            <br/>
            <TextField
                helperText="Groceries Budget"
                id="filled-start-adornment"
                sx={{ m: 1, width: '25ch' }}
                InputProps={{
                    startAdornment: <InputAdornment position="start">$</InputAdornment>,
                }}
                variant="standard"
                defaultValue={categories.groceries}
            />
            <TextField
                helperText="Utilities Budget"
                id="filled-start-adornment"
                sx={{ m: 1, width: '25ch' }}
                InputProps={{
                    startAdornment: <InputAdornment position="start">$</InputAdornment>,
                }}
                variant="standard"
                defaultValue={categories.utilities}
            />
            <br/>
            <TextField
                helperText="Food Budget"
                id="filled-start-adornment"
                sx={{ m: 1, width: '25ch' }}
                InputProps={{
                    startAdornment: <InputAdornment position="start">$</InputAdornment>,
                }}
                variant="standard"
                defaultValue={categories.food}
            />
            <TextField
                helperText="Others Budget"
                id="filled-start-adornment"
                sx={{ m: 1, width: '25ch' }}
                InputProps={{
                    startAdornment: <InputAdornment position="start">$</InputAdornment>,
                }}
                variant="standard"
                defaultValue={categories.other}
            />
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Cancel</Button>
            <Button onClick={handleOnUpdate} autoFocus style={{color: '#465098', width: '20%', fontSize: 'small', fontWeight: 'bold'}}>Update</Button>
      </DialogActions>
    </Dialog>
  );
}
