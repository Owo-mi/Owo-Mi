import { Request, Response, NextFunction } from 'express';
import { prisma } from '../config/prisma/Prismaclient';
import { JwtPayload} from "jwt-decode";
import { verify } from "jsonwebtoken"
import "dotenv/config";

const key = process.env.ENCRYPTION_KEY || '';

/*
A middleware that checks if sub exists in database
*
*
*@return {status} - A successful status if the sub does not exist. Else returns unsuccessful if sub does exist
*/
export const subExist = async (req: Request, res: Response, next: NextFunction) =>  {
    const { sub } = req.body.payload;

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

export const verifyToken = async (req: Request, res: Response, next: NextFunction) => {
    try {

        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
          return res.status(401).json({ message: 'Unauthorized' });
        }
    
        const token = authHeader.split(' ')[1];

        const decodedJwt = verify(token, key)as JwtPayload;

       req.body.payload = decodedJwt;

       return next()
    } catch (error) {

        console.error(error);

        // Handle different error types (e.g., token expiration)
        if (error === 'TokenExpiredError') {
          return res.status(401).json({ message: 'Token expired' });
        }
    
        return res.status(403).json({ message: 'Forbidden' }); // Or another appropriate error code
      }
    
}
