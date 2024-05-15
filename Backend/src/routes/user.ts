import { Router } from "express"
import { prisma } from "../config/prisma/Prismaclient"
import { encrypt, decrypt } from "../functions/general_function";
import { Request, Response } from "express";

import { subExist, verifyToken } from '../middleware/auth_option';

const router = Router();

router.get('/testing', async (req, res) => {
    try {
        const users = await prisma.user.findMany();
        res.json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error fetching users' });
    }
});


/**
 * Changes a users password from old to new
 *
 * @route POST /users/registration
 * @header {IdToken} - the user's id token
 * @body {string} - Users Address
 * @body {string} req.body.email - Users Email
 * @body {string} req.body.salt - Users Salt
 * @returns {status} - A successful status upon Registratiorn, returns 200 and a JSON object with a success message
 * @throws {Error} - If there are errors User Creation fails, returns 400 with an error message
 */
router.post('/resgitration',  verifyToken, subExist, async (req: Request, res: Response) => {
    try {
        if (req.body.payload) {
            const {sub}  = req.body.payload;
            const { address, salt, email} = req.body;
    
            // Validate user data (e.g., ensure sub and hashedPassword are present)
            // Encrypt Salt
            const hashedSalt = await encrypt(salt);
            // Create a new user with Prisma, storing the combined hash
            const user = await prisma.user.create({
                data: {
                    sub: sub,
                    address: address,
                    salt: hashedSalt,
                    email: email
                },
            });
            res.status(200).json({ message: 'User Signed In' })
        }else {
            return res.status(400).json({ message: 'User creation failed' });
        }

    } catch (error) {
        console.log(error)
        res.status(500).json({ message: 'Internal server error' });
    }
} )


/**
 * Changes a users password from old to new
 *
 * @route GET /users/salt
 * @header {IdToken} - the user's id token
 * @returns {status} - A successful status returns 200 and a JSON object containing decrypted Salt of th user
 * @throws {Error} - If there are errors User Creation fails, returns 400 with an error message
 */
router.get('/salt', verifyToken, async (req: Request, res: Response) => {
    try {
        const  {sub} = req.body.payload
        // Fetch user data from database using Prisma
        const user = await prisma.user.findUnique({
          where: { sub: sub },
        });
    
        if (!user) {
          return res.status(404).json({ message: 'User not found' });
        }
        const decrypted = decrypt(user.salt);
        res.status(200).json({salt: decrypted});
    
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
})

export default router;