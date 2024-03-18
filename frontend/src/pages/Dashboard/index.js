import React, { useState } from "react";
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Divider from '@mui/material/Divider';
import DrawerList from '../../components/DrawerList'
import DashboardTab from '../../components/DashboardTab'
import CreateExpenseModal from '../../components/CreateExpenseModal';
import Button from '@mui/material/Button';
import Receipt from '@mui/icons-material/Receipt';
import BarChartIcon from '@mui/icons-material/BarChart';
import { DRAWER_WIDTH } from '../../constants'
import "./index.css"

export default function Dashboard() {
    const [createExpenseModal, setCreateExpenseModal] = useState(false);
    const createExpenseToggle = () => setCreateExpenseModal(!createExpenseModal);
    return (
            <Box sx={{ display: 'flex' }}>
                <AppBar position="fixed" sx={{ width: `calc(100% - ${DRAWER_WIDTH}px)`, ml: `${DRAWER_WIDTH}px` }}>
                    <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                        <div className="toolBarTitle">Your BudgetWise Dashboard</div>
                        <div style={{width: '40%', display: 'flex', justifyContent: 'flex-end'}}>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginRight: '1rem'}} startIcon={<BarChartIcon/>}>Create Budget</Button>
                            <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold'}} startIcon={<Receipt/>} onClick={createExpenseToggle}>Add Expense</Button>
                        </div>
                    </Toolbar>
                </AppBar>
                <Drawer sx={{ width: DRAWER_WIDTH, flexShrink: 0, display: 'block', '& .MuiDrawer-paper': { width: DRAWER_WIDTH, boxSizing: 'border-box'}}} variant="permanent" anchor="left">
                    <Toolbar />
                    <Divider />
                    <DrawerList/>
                </Drawer>
                {/* Add toggle on tab change */}
                <div className="mainContainer">
                    <CreateExpenseModal modal={createExpenseModal} toggle={createExpenseToggle}/>
                    <DashboardTab/>
                </div>
            </Box>
    );
}