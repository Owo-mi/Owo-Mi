import { Request, Response, NextFunction } from 'express';
import { prisma } from '../config/prisma/Prismaclient';
import { JwtPayload, jwtDecode} from "jwt-decode";
import {TokenExpiredError} from "jsonwebtoken";
import "dotenv/config";
import { RequestWithUserRole, IdeCode } from '../types/types';
/*
A middleware that checks if sub exists in database
*
*
*@return {status} - A successful status if the sub does not exist. Else returns unsuccessful if sub does exist
*/
export const subExist = async (req: RequestWithUserRole, res: Response, next: NextFunction) =>  {
    const  sub  = req.user?.sub;

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

export const verifyToken = (secret: string) => async (req: Request&{user:IdeCode}, res: Response, next: NextFunction) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
          return res.status(401).json({ message: 'Unauthorized' });
        }
    
        const token = authHeader.split(' ')[1];

        
        if (!token) {
            return res.status(403).send("A token is required");
        }
        
        const decodedJwt = jwtDecode(token) as JwtPayload;
        console.log(JSON.stringify(decodedJwt, null, 2));

        req.user = decodedJwt;
        console.log(req.user)

       return next()
    } catch (error) {

        console.error(error);


        if(error instanceof TokenExpiredError) {
          return res.status(401).json({ message: 'Token expired' });
        }
    
        return res.status(403).json({ message: 'Forbidden' }); // Or another appropriate error code
      }
    
}
