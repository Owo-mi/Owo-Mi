import { Router } from "express"
import { prisma } from "../config/prisma/Prismaclient"
import { encrypt, decrypt } from "../functions/aes";

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




router.post('/signIn',  verifyToken, subExist, async (req, res) => {
    try {
        const { sub, salt} = req.body.payload; // Expect user data
        const { email, address } = req.body
        // Validate user data (e.g., ensure sub and hashedPassword are present)
        // Encrypt Salt
        const hashedSalt = await encrypt(salt);
        // Create a new user with Prisma, storing the combined hash
        const user = await prisma.user.create({
            data: {
                sub: sub,
                address: address,
                salt: hashedSalt.toString(), // Store the hashed salt (for potential future use)
                email: email
            },
        });
        if (!user) {
            return res.status(400).json({ message: 'User creation failed' });
        }
        res.json({ message: 'User Signed In' });

    } catch (error) {
        console.log(error)
        res.status(500).json({ message: 'Internal server error' });
    }
} )


router.get('/salt', verifyToken, async (req, res) => {
    try {
        const { sub } = req.body.payload;
        // Fetch user data from database using Prisma
        const user = await prisma.user.findUnique({
          where: { sub: sub },
        });
    
        if (!user) {
          return res.status(404).json({ message: 'User not found' });
        }
        const decrypted = user.salt;
        res.status(200).json({salt: decrypted});
    
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
})

export default router;