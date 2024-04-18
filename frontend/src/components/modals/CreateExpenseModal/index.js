import React, { useState } from 'react';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogTitle from '@mui/material/DialogTitle';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import MenuItem from '@mui/material/MenuItem';
import { categories } from '../../../constants';
import FileUploadIcon from '@mui/icons-material/FileUpload';
import HourglassBottomIcon from '@mui/icons-material/HourglassBottom';
import { createWorker } from 'tesseract.js';
import './index.css';


export default function CreateExpenseModal(props) {

  const { modal, toggle, method } = props;

  // State variables to store values from text fields
  const [expenseName, setExpenseName] = useState('');
  const [expenseCategory, setExpenseCategory] = useState('');
  const [expenseAmount, setExpenseAmount] = useState('');
  const [fileName, setFileName] = useState('No file chosen');
  const [loading, setLoading] = useState(false);

  const reset = () => {
    setExpenseName('')
    setExpenseCategory('')
    setExpenseAmount('')
    setFileName('No file chosen')
  }

  const handleSubmit = async () => {
    toggle();
    reset();
  };

  const handleCreateExpense = async () => {
    const createExpense = {
      name: expenseName,
      category: expenseCategory,
      amount: expenseAmount,
    };
    method(createExpense)
    toggle();
    reset();
  };

  function extractFilename(path) {
    // eslint-disable-next-line no-useless-escape
    const parts = path.split(/[\\\/]/);
    return parts[parts.length - 1];
  }

  const handleFileName = async (e) => {
    setLoading(true)
    // set file name
    const file = e.target.value;
    setFileName(extractFilename(file));
    // read file data
    const fileDoc = document.getElementById("actual-btn").files[0];
    const worker = await createWorker('eng');
    const ret = await worker.recognize(fileDoc);
    const text = ret.data.text
    await worker.terminate();
    const regex = /(AMOUNT|Total)\s+(\d+\.\d+)/i;
    const match = text.match(regex);
    if (match && match[2]) {
      setExpenseAmount(parseFloat(match[2]))
    } else {
      setExpenseAmount(0)
    }
    setLoading(false)
    setExpenseName("Receipt");
    setExpenseCategory("Other")
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
                value={expenseName}
                onChange={(e) => setExpenseName(e.target.value)}
            />
            <TextField
                id="standard-select-category"
                select
                sx={{ m: 1, width: '40%' }}
                variant='standard'
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
                style={{marginBottom: '2rem'}}
                variant="standard"
                value={expenseAmount}
                onChange={(e) => setExpenseAmount(parseFloat(e.target.value))}
            />
            <br/>
            <input className="fileInput" type="file" id="actual-btn" hidden onChange={(e) => handleFileName(e)}/>
            <label className="fileUploadLabel" for="actual-btn"><FileUploadIcon fontSize="small" style={{marginRight: ".3rem"}}/>UPLOAD RECEIPT INSTEAD</label>
            <div className="fileChosen">{fileName}</div>
            { loading === true ?
            <div className='loading'>
                <HourglassBottomIcon fontSize='small' style={{marginRight: ".5rem"}}/>
                Processing your receipt...
            </div> : <div/>
            }
        </DialogContent>
        <DialogActions>
            <Button onClick={handleSubmit} style={{color: '#465098', width: '15%', fontSize: 'small', fontWeight: 'bold'}}>Cancel</Button>
            <Button onClick={handleCreateExpense} autoFocus style={{color: '#465098', width: '20%', fontSize: 'small', fontWeight: 'bold'}}> Add Expense</Button>
      </DialogActions>
    </Dialog>
  );
}
