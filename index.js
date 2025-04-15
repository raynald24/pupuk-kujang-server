import express from "express";
import cors from "cors";
import db from "./config/database.js";
import SequelizeStore from "connect-session-sequelize";
import session from "express-session";
import dotenv from "dotenv";
import UserROute from './routes/UserROute.js';  
import AuthRoute from "./routes/AuthRoute.js";
import SampleRoute from './routes/SampleRoute.js';  
import Sample from './models/SampleModel.js';  

dotenv.config();

const app = express();

// Session store configuration
const sessionStore = SequelizeStore(session.Store);
const store = new sessionStore({
    db: db
});

// Synchronize database
(async () => {
    try {
        await db.authenticate();
        console.log("Database connected!");
        await Sample.sync(); // Mengsinkronisasi model Sample dengan database
        console.log("Database synced!");
    } catch (error) {
        console.error("Error syncing database:", error);
    }
})();

// Express session middleware
app.use(session({
    secret: process.env.SESS_SECRET,
    resave: false,
    saveUninitialized: true,
    store: store,
    cookie: {
        secure: process.env.NODE_ENV === 'production' // hanya true di production
    }
}));

// Middlewares
app.use(cors({
    credentials: true,
    origin: 'http://localhost:5173'  // URL frontend (React)
}));
app.use(express.json());

// Routes
app.use(UserROute);  // Rute untuk users
app.use(AuthRoute);   // Rute untuk auth
app.use(SampleRoute);  // Rute untuk sample

// Start server
const PORT = process.env.APP_PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
