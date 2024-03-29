import React from "react";
import './index.css'
import BarChartIcon from '@mui/icons-material/BarChart';
import Button from '@mui/material/Button';

export default function ProfileTab() {
    return (
        <div className="dashTabContainer">
            <div className="profileContainer">
                <div className="profileEntry">Name: </div>
                <div className="profileEntry">Email: </div>
                <div className="profileEntry">Phone Number: </div>
                <Button style={{backgroundColor: 'white', color: '#465098', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginRight: '1rem', marginTop: '5rem'}} startIcon={<BarChartIcon/>}>Update Profile</Button>
            </div>
        </div>
    )
}