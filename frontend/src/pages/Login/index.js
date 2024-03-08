import React, { useState } from "react";
import { Button, Tab, Tabs, TextField } from "@mui/material";
import { LOGIN_IMAGE_URL } from '../../constants'
import "./login.css"

export default function Login() {
    const [currentTabIndex, setCurrentTabIndex] = useState(0);

    const handleTabChange = (e, tabIndex) => {
        console.log(tabIndex);
        setCurrentTabIndex(tabIndex);
      };

    const handleLoginOnClick = () => {
        // fill in with login API
        // navigate to dashboard screen
    }

    return (
        <div className="container">
            <div className="subContainer"> 
                <img src={LOGIN_IMAGE_URL} alt="login page" className="image"/>
                <div className="footer">Elevate Your Financial Management: Data-driven Insights</div>
            </div>
            <div className="tabContainer">
                <div className="title">BudgetWise</div>
                <React.Fragment>
                <Tabs value={currentTabIndex} onChange={handleTabChange} centered>
                    <Tab label='Login' style={{color: "#465098"}}/>
                    <Tab label='Register' style={{color: "#465098"}}/>
                </Tabs>
                {/* TAB 1 Contents */}
                {currentTabIndex === 0 && (
                    <div className="tab">
                        <TextField label="Email" variant="outlined" size="small" fullWidth margin="normal" required/>
                        <TextField label="Password" variant="outlined" size="small" fullWidth margin="normal" required/>
                        <Button style={{backgroundColor: "#465098", marginTop: "1rem"}} variant="contained" margin="normal" fullWidth onClick={handleLoginOnClick}>LOGIN</Button>
                        <div className="tabFooter">Don't have an account? Register</div>
                    </div>
                )}
                {/* TAB 2 Contents */}
                {currentTabIndex === 1 && (
                    <div className="tab">
                    <TextField label="Name" variant="outlined" size="small" fullWidth margin="normal" required/>
                    <TextField label="Email" variant="outlined" size="small" fullWidth margin="normal" required/>
                    <TextField label="Phone" variant="outlined" size="small" fullWidth margin="normal" required/>
                    <TextField label="Password" variant="outlined" size="small" fullWidth margin="normal" required/>
                    <Button style={{backgroundColor: "#465098", marginTop: "1rem"}} variant="contained" margin="normal" fullWidth>REGISTER</Button>
                    <div className="tabFooter">Already have have an account? Login</div>
                </div>
                )}
                </React.Fragment>
            </div>
        </div>
    );
    }
    
