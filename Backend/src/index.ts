// A simple server
import http from 'http';
import "dotenv/config";
import express from 'express';
import bodyParser from 'body-parser';
import { Request, Response } from 'express';

import { prisma } from './config/prisma/Prismaclient';
import userRoutes from './routes/user';


const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
const BASE_PATH = process.env.BASE_PATH || '/api';

app.use("/health", (req, res) => {
  res.status(200).send('OK');
});

app.use(BASE_PATH, async (req: Request, res: Response) => {
  res.status(200).json({
    message: 'Hello World'
  });
});

app.use(`${BASE_PATH}/users`, userRoutes);



const server = http.createServer(app);
const port = process.env.PORT || 3000

process.on('SIGINT', async () => {
  await prisma.$disconnect();
  process.exit();
});

server.listen(port, () => {
  console.log(`API started at http://localhost:${port}`);
});
