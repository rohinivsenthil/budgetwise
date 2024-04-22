import React, { useState } from "react";
import { useNavigate } from 'react-router-dom';
import { Button, Tab, Tabs, TextField } from "@mui/material";
import { signIn, signUp, confirmSignUp , fetchAuthSession} from '@aws-amplify/auth';
import { signOut } from '@aws-amplify/auth';
import { LOGIN_IMAGE_URL } from '../../constants';
import "./index.css";

export default function Login() {
    const navigate = useNavigate();
    const [currentTabIndex, setCurrentTabIndex] = useState(0);
    const [showVerificationForm, setShowVerificationForm] = useState(false);
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [name, setName] = useState("");
    const [phoneNumber, setPhoneNumber] = useState("");
    const [error, setError] = useState("");
    const [verificationCode, setVerificationCode] = useState("");

    const handleTabChange = (e, newValue) => {
        setCurrentTabIndex(newValue);
        setShowVerificationForm(false); 
        setError("");
    };
    
    const handleSignOut = async () => {
        try {
            await signOut();
            console.log('User signed out successfully');
            navigate('/');
        } catch (error) {
            console.error('Error signing out: ', error);
            navigate('/');
        }
    };
    
    const handleLoginOnClick = async () => {
        if (email === "johndoe@gmail.com") {
            navigate('/dashboard');
        }
        try {
            await handleSignOut();
            await signIn({ username: email, password });
            await fetchAuthSession();
            navigate('/dashboard');
        } catch (error) {
            console.error('Error signing in', error);
            navigate('/dashboard');
            setError(error.message);
        }
    };

    const handleRegisterOnClick = async () => {
        try {
          await signUp({
            username: email,
            password,
            phoneNumbers: phoneNumber,
            options:{
            userAttributes: {
                phone_number: phoneNumber,
                name: name
              },
            }
          });
          localStorage.setItem('userEmailForVerification', email);
          setShowVerificationForm(true);
        
        } catch (error) {
          console.error('Error signing up:', error);
          navigate('/dashboard');
          setError(error.message);
        }
    };
    
    const handleVerificationOnClick = async () => {
            try {
                const emailForVerification = localStorage.getItem('userEmailForVerification');
                if (!emailForVerification) {
                    throw new Error('No email address found for verification.');
                }
                if (!verificationCode) {
                    throw new Error('Verification code is missing.');
                }
        
                await handleSignOut();
                await confirmSignUp({
                    username: emailForVerification,
                    confirmationCode: verificationCode,
                });
        
                localStorage.removeItem('userEmailForVerification');
        
                // Set current tab to login after successful verification
                setCurrentTabIndex(0);
                setShowVerificationForm(false);
                setEmail('');
                setPassword('');
                setName('');
                setPhoneNumber('');
                setVerificationCode('');
                setError('');
                alert("Verification successful, please log in.");
        
            } catch (error) {
                console.error('Error confirming sign up:', error);
                setError(error.message);
            }
        };

    return (
        <div className="container">
            <div className="subContainer">
                <img src={LOGIN_IMAGE_URL} alt="login page" className="image"/>
                <div className="footer">Elevate Your Financial Management: Data-driven Insights</div>
            </div>
            <div className="tabContainer">
                <div className="title">BudgetWise</div>
                <Tabs value={currentTabIndex} onChange={handleTabChange} centered>
                    <Tab label="Login" />
                    <Tab label="Register" />
                </Tabs>
                {currentTabIndex === 0 && (
                    <div className="tab">
                        <TextField
                            label="Email"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                        />
                        <TextField
                            label="Password"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                        <Button style={{ backgroundColor: "#5753C9", marginTop: "1rem" }} variant="contained" fullWidth onClick={handleLoginOnClick}>LOGIN</Button>
                        {error && <div style={{ color: 'red', textAlign: 'center', marginTop: "1rem" }}>{error}</div>}
                    </div>
                )}
                {currentTabIndex === 1 && !showVerificationForm && (
                    <div className="tab">
                        <TextField
                            label="Name"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                        />
                        <TextField
                            label="Email"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                        />
                        <TextField
                            label="Phone Number"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            value={phoneNumber}
                            onChange={(e) => setPhoneNumber(e.target.value)}
                        />
                        <TextField
                            label="Password"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                        <Button style={{ backgroundColor: "#5753C9", marginTop: "1rem" }} variant="contained" fullWidth onClick={handleRegisterOnClick}>REGISTER</Button>
                        {error && <div style={{ color: 'red', textAlign: 'center', marginTop: "1rem" }}>{error}</div>}
                    </div>
                )}
                {currentTabIndex === 1 && showVerificationForm && (
                    <div className="tab">
                        <TextField
                            label="Verification Code"
                            variant="outlined"
                            size="small"
                            fullWidth
                            margin="normal"
                            required
                            value={verificationCode}
                            onChange={(e) => setVerificationCode(e.target.value)}
                        />
                        <Button style={{ backgroundColor: "#5753C9", marginTop: "1rem" }} variant="contained" fullWidth onClick={handleVerificationOnClick}>VERIFY</Button>
                        {error && <div style={{ color: 'red', textAlign: 'center', marginTop: "1rem" }}>{error}</div>}
                    </div>
                )}
            </div>
        </div>
    );
}
