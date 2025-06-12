import express from "express";
import cors from "cors";
import db from "./config/database.js";
import SequelizeStore from "connect-session-sequelize";
import session from "express-session";
import dotenv from "dotenv";

// Routes
import UserRoute from './routes/UserROute.js';
import AuthRoute from "./routes/AuthRoute.js";
import SampleRoute from './routes/SampleRoute.js';
import AnalisisRoute from './routes/AnalisisRoute.js';

// Models
import Sample from './models/SampleModel.js';
import namaBahan from './models/namaBahan.js';
import Parameter from './models/parameters.js';
import AnalysisResult from "./models/AnalysisResult.js";
import ParameterInput from "./models/ParameterInput.js";
import Users from './models/UserModel.js';

dotenv.config();

const defineRelations = () => {
  Users.hasMany(Sample);
  Sample.belongsTo(Users, { foreignKey: 'userId' });

  namaBahan.hasMany(Sample, { foreignKey: 'namaBahanId' });
  Sample.belongsTo(namaBahan, { foreignKey: 'namaBahanId' });

  namaBahan.hasMany(Parameter, { foreignKey: 'namaBahanId' });
  Parameter.belongsTo(namaBahan, { foreignKey: 'namaBahanId' });

  // Relasi Sample dan AnalysisResult
  Sample.hasMany(AnalysisResult, { foreignKey: 'sampleId', onDelete: 'CASCADE' });
  AnalysisResult.belongsTo(Sample, { foreignKey: 'sampleId', onDelete: 'CASCADE' });

  AnalysisResult.belongsTo(Parameter, {
    foreignKey: 'parameterId',
    as: 'Parameter'
  });

  AnalysisResult.hasMany(ParameterInput, {
    foreignKey: 'analysisId',
    as: 'ParameterInputs',
    onDelete: 'CASCADE'
  });

  ParameterInput.belongsTo(AnalysisResult, {
    foreignKey: 'analysisId',
    as: 'AnalysisResult',
    onDelete: 'CASCADE'
  });

  ParameterInput.belongsTo(Parameter, {
    foreignKey: 'parameterId',
    as: 'Parameter'
  });
};

const app = express();

// Session store
const sessionStore = SequelizeStore(session.Store);
const store = new sessionStore({
  db: db
});

// Sync DB dan relasi
(async () => {
  try {
    await db.authenticate();
    console.log("Database connected!");
    defineRelations();
    await db.sync({ alter: true });
    await store.sync();
    console.log("Database and session store synced!");
  } catch (error) {
    console.error("Error syncing database:", error);
  }
})();

// Session middleware
app.use(session({
  secret: process.env.SESS_SECRET,
  resave: false,
  saveUninitialized: true,
  store: store,
  cookie: {
    secure: process.env.NODE_ENV === 'production'
  }
}));

// Middleware lainnya
app.use(cors({
  credentials: true,
  origin: 'http://localhost:5173'
}));
app.use(express.json({ limit: '1mb' }));

// Routes
app.use(UserRoute);
app.use(AuthRoute);
app.use(SampleRoute);
app.use('/analisis', AnalisisRoute);

// Debug rute
app._router.stack.forEach((r) => {
  if (r.route && r.route.path) {
    console.log(`Registered route: ${r.route.path}`);
  }
});

// Jalankan server
const PORT = process.env.APP_PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
