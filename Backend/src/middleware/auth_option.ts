import { Request, Response, NextFunction } from 'express';
import { prisma } from '../config/prisma/Prismaclient';
import {TokenExpiredError} from "jsonwebtoken";
//import { JwtPayload, jwtDecode } from 'jwt-decode';
//import { verify } from '../functions/general_function';
import { OAuth2Client, TokenPayload } from 'google-auth-library';
import "dotenv/config";
/*
A middleware that checks if sub exists in database
*
*
*@return {status} - A successful status if the sub does not exist. Else returns unsuccessful if sub does exist
*/
export const subExist = async (req: Request, res: Response, next: NextFunction) =>  {
    const  { sub }  = req.body.payload;

    try {
        const existingUser = await prisma.user.findUnique({
            where: {
                sub: sub,
            },
        });

        if (existingUser) {
            return res.status(400).json({ message: 'User with this sub already exists' });
        }

        next(); // Move to the next middleware or route handler
    } catch (error) {
        console.error('Error checking sub existence:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

const client = new OAuth2Client(process.env.CLIENT_ID, process.env.CLIENT_SECRET);

export const verifyToken = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader?.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'Unauthorized' });
      }
      const token = authHeader.split(' ')[1];
      if (!token) {
        return res.status(403).send("A token is required");
      }
      const ticket = await client.verifyIdToken({
        idToken: token,
        audience: process.env.CLIENT_ID,
      });
      const payload = ticket.getPayload() as TokenPayload;
      if (payload) {
        req.body.payload = payload;
      next();  
    }
    } catch (error) {
      console.error(error);
      if (error instanceof TokenExpiredError) {
        return res.status(401).json({ message: 'Token expired' });
      }
      return res.status(403).json({ message: 'Forbidden' });
    }
  };