const express = require('express');
const cors = require('cors');
const BaasClient = require('baas').Client;
const appName = require('./package.json').name;

const app = express();
const PORT = process.env.PORT || 3000;
const LB_HOST = process.env.LB_HOST || 3000;

const baas = new BaasClient({
    port: 9485,
    host: LB_HOST,
    protocol: 'baass',
    pool: {
        maxConnections: 20,
        maxRequestsPerConnection: 10
    }
});

// enable CORS
app.use(cors());

// parse application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: false }));

// parse application/json
app.use(express.json());

app.post('/hash', (req, res) => {
    const { password } = req.body;
    baas.hash(password, (err, hash) => {
        if (err) {
            res.status(404).send(`Error: ${err.message}`);
        } else {
            res.status(200).send(hash);
        }
    });
});

app.post('/compare', (req, res) => {
    const { password, hash } = req.body;
    baas.compare(password, hash, (err, success) => {
        if (err) {
            res.status(404).send(`Error: ${err.message}`);
        } else {
            res.status(200).send(success);
        }
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'OK'
    });
});

app.listen(PORT, () => {
    console.log(`${appName} listening on port ${PORT}!`);
});
