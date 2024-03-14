import React from "react";
import Box from '@mui/material/Box';
import Drawer from '@mui/material/Drawer';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Divider from '@mui/material/Divider';
import DrawerList from '../../components/DrawerList'
import DashboardTab from '../../components/DashboardTab'
import Button from '@mui/material/Button';
import Receipt from '@mui/icons-material/Receipt';
import { DRAWER_WIDTH } from '../../constants'
import './dashboard.css'

export default function Dashboard() {
    return (
        <Box sx={{ display: 'flex' }}>
            <AppBar position="fixed" sx={{ width: `calc(100% - ${DRAWER_WIDTH}px)`, ml: `${DRAWER_WIDTH}px` }}>
                <Toolbar style={{backgroundColor: "#5753C9", display: 'flex', justifyContent: 'space-between'}}>
                    <div className="toolBarTitle">Your BudgetWise Dashboard</div>
                    <Button style={{backgroundColor: 'whitesmoke', color: '#465098', fontSize: 'small', width: '20%', fontWeight: 'bold'}} startIcon={<Receipt/>}>Add Expense</Button>
                </Toolbar>
            </AppBar>
            <Drawer sx={{ width: DRAWER_WIDTH, flexShrink: 0, display: 'block', '& .MuiDrawer-paper': { width: DRAWER_WIDTH, boxSizing: 'border-box'}}} variant="permanent" anchor="left">
                <Toolbar />
                <Divider />
                <DrawerList/>
            </Drawer>
            {/* Add toggle on tab change */}
            <div className="mainContainer">
                <DashboardTab/>
            </div>
        </Box>
    );
}