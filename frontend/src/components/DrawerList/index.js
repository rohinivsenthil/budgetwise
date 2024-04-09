import React from "react";
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import DashboardIcon from '@mui/icons-material/Dashboard';
import PersonIcon from '@mui/icons-material/Person';

export default function DrawerList(props) {
    const { setTab } = props;
    return (
        <List>
            <ListItem disablePadding>
                <ListItemButton onClick={() => setTab(0)}>
                    <ListItemIcon><DashboardIcon style={{color: '#465098'}}/></ListItemIcon>
                    <ListItemText primary={"Dashboard"} />
                </ListItemButton>
            </ListItem>
            <ListItem disablePadding>
                <ListItemButton onClick={() => setTab(1)}>
                    <ListItemIcon><PersonIcon style={{color: '#465098'}}/></ListItemIcon>
                    <ListItemText primary={"Profile"} />
                </ListItemButton>
            </ListItem>
        </List>
    );
}