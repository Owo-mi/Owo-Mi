// A simple server
import http from 'http';
import "dotenv/config";
import express from 'express';
import bodyParser from 'body-parser';
import { Request, Response } from 'express';
const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.get('/', async (req: Request, res: Response) => {
  res.status(200).json({
    message: 'Hello World'
  });
});

const server = http.createServer(app);
const port = process.env.PORT || 3000
server.listen(port, () => {
  console.log(`API started at http://localhost:${port}`);
});
