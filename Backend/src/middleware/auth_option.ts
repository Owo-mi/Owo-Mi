import { Request, Response, NextFunction } from 'express';
import { prisma } from '../config/prisma/Prismaclient';

/*
A middleware that checks if sub exists in database
*
*
*@return {status} - A successful status if the sub does not exist. Else returns unsuccessful if sub does exist
*/
export const subExist = async (req: Request, res: Response, next: NextFunction) =>  {
    const { sub } = req.body;

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