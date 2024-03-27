import React, { useState } from "react";
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Divider from '@mui/material/Divider';
import DrawerList from '../../components/DrawerList'
import DashboardTab from '../../components/DashboardTab'
import ProfileTab from '../../components/ProfileTab'
import CreateExpenseModal from '../../components/CreateExpenseModal';
import DeleteExpenseModal from '../../components/DeleteExpenseModal';
import UpdateExpenseModal from '../../components/UpdateExpenseModal';
import Button from '@mui/material/Button';
import Receipt from '@mui/icons-material/Receipt';
import BarChartIcon from '@mui/icons-material/BarChart';
import LogoutIcon from '@mui/icons-material/Logout';
import { DRAWER_WIDTH } from '../../constants'
import "./index.css"

export default function Dashboard() {
    const [focusItem, setFocusItem] = useState({date: '', name: '', category: '', amount: ''})
    const [tab, setTab] = useState(0);

    const [createExpenseModal, setCreateExpenseModal] = useState(false);
    const createExpenseToggle = () => setCreateExpenseModal(!createExpenseModal);

    const [deleteExpenseModal, setDeleteExpenseModal] = useState(false);
    const deleteExpenseToggle = () => setDeleteExpenseModal(!deleteExpenseModal);

    const [updateExpenseModal, setUpdateExpenseModal] = useState(false);
    const updateExpenseToggle = () => setUpdateExpenseModal(!updateExpenseModal);

    return (
            <Box sx={{ display: 'flex' }}>
                <AppBar position="fixed" sx={{ width: `calc(100% - ${DRAWER_WIDTH}px)`, ml: `${DRAWER_WIDTH}px` }}>
                    { tab === 0? 
                    <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                        <div className="toolBarTitle">Your BudgetWise Dashboard</div>
                        <div style={{width: '40%', display: 'flex', justifyContent: 'flex-end'}}>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<BarChartIcon/>}>Create Budget</Button>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold'}} startIcon={<Receipt/>} onClick={createExpenseToggle}>Add Expense</Button>
                        </div>
                    </Toolbar>
                    :
                    <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                        <div className="toolBarTitle">Your BudgetWise Profile</div>
                        <div style={{width: '40%', display: 'flex', justifyContent: 'flex-end'}}>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<LogoutIcon/>}> Logout</Button>
                        </div>
                    </Toolbar>
                    }
                </AppBar>
                <Drawer sx={{ width: DRAWER_WIDTH, flexShrink: 0, display: 'block', '& .MuiDrawer-paper': { width: DRAWER_WIDTH, boxSizing: 'border-box'}}} variant="permanent" anchor="left" >
                    <Toolbar style={{backgroundColor: '#cad0fb'}} />
                    <Divider />
                    <DrawerList setTab={setTab}/>
                </Drawer>
                { tab === 0 ?
                <div className="mainContainer">
                    <CreateExpenseModal modal={createExpenseModal} toggle={createExpenseToggle}/>
                    <DeleteExpenseModal modal={deleteExpenseModal} toggle={deleteExpenseToggle}/>
                    <UpdateExpenseModal modal={updateExpenseModal} toggle={updateExpenseToggle} focusItem={focusItem}/>
                    <DashboardTab deleteExpenseToggle={deleteExpenseToggle} updateExpenseToggle={updateExpenseToggle} setFocusItem={setFocusItem}/>
                </div>
                :
                <div className="mainContainer">
                    <ProfileTab/>
                </div>
                }
            </Box>
    );
}