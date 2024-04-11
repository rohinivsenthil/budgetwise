import React from "react";
import './index.css'
import Button from '@mui/material/Button';
import EditIcon from '@mui/icons-material/Edit';

export default function ProfileTab() {
    return (
        <div className="dashTabContainer">
            <div className="profileContainer">
                <div className="profileEntry">
                    <div className="profileField">Name:</div>
                    <div className="profileValue">John Doe</div>
                </div>
                <div className="profileEntry">
                    <div className="profileField">Email:</div>
                    <div className="profileValue">johndoe@example.com</div>
                </div>
                <div className="profileEntry">
                    <div className="profileField">Phone:</div>
                    <div className="profileValue">+1 (585) xxx xxx</div>
                </div>
                <Button style={{backgroundColor: '#5753C9', color: 'white', fontSize: 'x-small', width: '35%', fontWeight: 'bold', marginTop: '6rem'}} startIcon={<EditIcon/>}>Update Profile</Button>
            </div>
        </div>
    )
}