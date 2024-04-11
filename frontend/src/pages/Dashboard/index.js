import React, { useState, useEffect } from "react";
import axios from 'axios';
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Divider from '@mui/material/Divider';
import DrawerList from '../../components/DrawerList'
import DashboardTab from '../../components/tabs/DashboardTab'
import ProfileTab from '../../components/tabs/ProfileTab'
import BudgetTab from '../../components/tabs/BudgetTab'
import CreateExpenseModal from '../../components/modals/CreateExpenseModal';
import DeleteExpenseModal from '../../components/modals/DeleteExpenseModal';
import UpdateExpenseModal from '../../components/modals/UpdateExpenseModal';
import CreateBudgetModal from "../../components/modals/CreateBudgetModal";
import UpdateBudgetModal from '../../components/modals/UpdateBudgetModal';
import Button from '@mui/material/Button';
import Receipt from '@mui/icons-material/Receipt';
import BarChartIcon from '@mui/icons-material/BarChart';
import LogoutIcon from '@mui/icons-material/Logout';
import TimelineIcon from '@mui/icons-material/Timeline';
import { DRAWER_WIDTH } from '../../constants'
import "./index.css"
import { API_URL } from "../../config";

export default function Dashboard() {
    const [focusItem, setFocusItem] = useState({date: '', name: '', category: '', amount: '', expense_id: ''})
    const [tab, setTab] = useState(0);

    const [createExpenseModal, setCreateExpenseModal] = useState(false);
    const createExpenseToggle = () => setCreateExpenseModal(!createExpenseModal);

    const [createBudgetModal, setCreateBudgetModal] = useState(false);
    const createBudgetToggle = () => setCreateBudgetModal(!createBudgetModal);

    const [deleteExpenseModal, setDeleteExpenseModal] = useState(false);
    const deleteExpenseToggle = () => setDeleteExpenseModal(!deleteExpenseModal);

    const [updateExpenseModal, setUpdateExpenseModal] = useState(false);
    const updateExpenseToggle = () => setUpdateExpenseModal(!updateExpenseModal);

    const [updateBudgetModal, setUpdateBudgetModal] = useState(false);
    const updateBudgetToggle = () => setUpdateBudgetModal(!updateBudgetModal);

    const [expenses, setExpenses] = useState([]);
    const [budgets, setBudgets] = useState([{"amount": 0.0, "categories": "{\"food\":0,\"groceries\":0,\"other\":0,\"utilities\":0}"}]);

    const createExpense = async (data) => {
        try {
          await axios.post(`${API_URL}/expenses`, data);
        } catch (error) {
          console.error('Error creating expense:', error);
        }
    }
    
    const editExpense = async (data) => {
        try {
            await axios.put(`${API_URL}/expenses`, data);
        } catch (error) {
            console.error('Error editing expense:', error);
        }
    }

    const editBudget = async (data) => {
      try {
          await axios.put(`${API_URL}/budgets`, data);
      } catch (error) {
          console.error('Error updating budget:', error);
      }
    }

    const deleteExpense = async (data) => {
        try {
          await axios.delete(`${API_URL}/expenses`, data);
        } catch (error) {
          console.error('Error deleting expense:', error);
        }
    }

    const createReport = async () => {
      try {
        await axios.post(`${API_URL}/reports`);
      } catch (error) {
        console.error('Error creating report:', error);
      }
    }

    useEffect(() => {
        const fetchExpenses = async () => {
          try {
            const response = await axios.get(`${API_URL}/expenses`);
            setExpenses(response.data.Items);
          } catch (error) {
            console.error('Error fetching expenses:', error);
          }
        };
        fetchExpenses();

        const fetchBudgets = async () => {
            try {
              const response = await axios.get(`${API_URL}/budgets`);
              setBudgets(response.data.Items);
            } catch (error) {
              console.error('Error fetching budgets:', error);
            }
          };
          fetchBudgets();

      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    return (
            <Box sx={{ display: 'flex' }}>
                <AppBar position="fixed" sx={{ width: `calc(100% - ${DRAWER_WIDTH}px)`, ml: `${DRAWER_WIDTH}px` }}>
                    {tab === 0 && (
                      <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                        <div className="toolBarTitle">Your BudgetWise Dashboard</div>
                        <div style={{width: '40%', display: 'flex', justifyContent: 'flex-end'}}>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '42%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<TimelineIcon/>} onClick={createReport}>Generate Report</Button>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '40%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<BarChartIcon/>} onClick={createBudgetToggle}>Create Budget</Button>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold'}} startIcon={<Receipt/>} onClick={createExpenseToggle}>Add Expense</Button>
                        </div>
                      </Toolbar>
                    )}
                    {tab === 2 && (
                      <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                          <div className="toolBarTitle">Your BudgetWise Profile</div>
                          <div style={{width: '40%', display: 'flex', justifyContent: 'flex-end'}}>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<LogoutIcon/>}> Logout</Button>
                          </div>
                      </Toolbar>
                    )}
                    {tab === 1 && (
                      <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                        <div className="toolBarTitle">Your BudgetWise Budget</div>
                      </Toolbar>
                    )}
                </AppBar>
                <Drawer sx={{ width: DRAWER_WIDTH, flexShrink: 0, display: 'block', '& .MuiDrawer-paper': { width: DRAWER_WIDTH, boxSizing: 'border-box'}}} variant="permanent" anchor="left" >
                    <Toolbar style={{backgroundColor: '#cad0fb'}} />
                    <Divider />
                    <DrawerList setTab={setTab}/>
                </Drawer>
                <div className="mainContainer">
                  {tab === 0 && (
                      <>
                          <CreateExpenseModal modal={createExpenseModal} toggle={createExpenseToggle} method={createExpense}/>
                          <DeleteExpenseModal modal={deleteExpenseModal} toggle={deleteExpenseToggle} method={deleteExpense} focusItem={focusItem}/>
                          <UpdateExpenseModal modal={updateExpenseModal} toggle={updateExpenseToggle} focusItem={focusItem} method={editExpense}/>
                          <CreateBudgetModal modal={createBudgetModal} toggle={createBudgetToggle}/>
                          <DashboardTab deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem} expenses={expenses} budgets={budgets}/>
                      </>
                  )}
                  {tab === 2 && <ProfileTab/>}
                  {tab === 1 && (
                      <>
                        <BudgetTab budgets={budgets} updateBudgetToggle={updateBudgetToggle}/>
                        <UpdateBudgetModal modal={updateBudgetModal} toggle={updateBudgetToggle} focusItem={budgets} method={editBudget}/>
                      </>
                  )}
                </div>
            </Box>
    );
}