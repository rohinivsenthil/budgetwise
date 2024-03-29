import React from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import MenuItem from '@mui/material/MenuItem';
import {categories} from '../../constants'
import FileUploadIcon from '@mui/icons-material/FileUpload';

export default function CreateExpenseModal(props) {

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
            {"Enter your expense details"}
        </DialogTitle>
        <DialogContent>
            <TextField
                id="standard-start-adornment"
                sx={{ m: 1, width: '40%' }}
                variant="standard"
                helperText="Expense Name"
            />
            <TextField
                id="standard-select-category"
                select
                sx={{ m: 1, width: '40%' }}
                variant='standard'
                helperText="Expense Category"
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
            />
            <br/>
            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginTop: '1rem'}} startIcon={<FileUploadIcon/>}> 
              Upload Receipt Instead 
              <input type="file" hidden style={{width: '100%'}}/>
            </Button>
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Cancel</Button>
            <Button onClick={handleSubmit} autoFocus style={{color: '#465098', width: '20%', fontSize: 'small', fontWeight: 'bold'}}> Add Expense</Button>
      </DialogActions>
    </Dialog>
  );
}
