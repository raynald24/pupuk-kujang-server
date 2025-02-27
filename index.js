import express from "express";
import cors from "cors";
import db from "./config/database.js";
import SequelizeStore from "connect-session-sequelize";
import session from "express-session";
import dotenv from "dotenv";
import UserROute from './routes/UserROute.js';
import AuthRoute from "./routes/AuthRoute.js";

dotenv.config();    

const app = express();

const sessionStore = SequelizeStore(session.Store);

const store = new sessionStore({
    db: db
});

(async () => {
    try {
        await db.authenticate();  
        console.log("Database connected!");
        // await Users.sync({ force: true }); 
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
        secure: 'auto' 
    }
}));

// Middlewares
app.use(cors({
    credentials: true,
    origin: 'http://localhost:5173'
}));
app.use(express.json());

// store.sync();

// Routes
app.use(UserROute);
app.use(AuthRoute);

// Server running
app.listen(process.env.APP_PORT, () => {
    console.log(`Server is running on port ${process.env.APP_PORT}`);
});
