// config.js
import axios from 'axios';
const config = (await axios.get("/config.json")).data;
export const API_URL = config.API_URL;
