const express = require("express");
const cors = require("cors");
const routes = require("./routes/routes");
require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

// uncertain of the correct way to construct CORS, skipping for now
// const corsOptions = {
//     origin: [
//         'http://10.0.2.2:3000', // android emulators
//         'http://127.0.0.1:3000', // iOS emulators
//     ]
// }

// app.use(cors(corsOptions));

app.use((req, res, next) => {
    console.log(`Request: ${req.method} ${req.url}`);
    next(); 
});

app.use(cors());

app.use(express.json());

app.use(routes);

app.listen(port, () => {
    console.log(`Server running @ port ${port}`);
});
