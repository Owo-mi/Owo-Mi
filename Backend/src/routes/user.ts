import { Router } from "express"
import { prisma } from "../config/prisma/Prismaclient"
import { generateHashedSalt } from "../functions/general_functions";
import * as bcrypt from 'bcrypt';
import { subExist } from '../middleware/auth_option';
import { jwtDecode } from "jwt-decode";

const router = Router();

router.get('/', async (req, res) => {
    try {
        const users = await prisma.user.findMany();
        res.json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error fetching users' });
    }
});




router.post('/registration', subExist, async (req, res) => {
    try {
        const { sub, hashedPassword, salt } = req.body; // Expect user data
        // Validate user data (e.g., ensure sub and hashedPassword are present)
        // Generate a secure random salt
        // Hash the salt using a strong algorithm like bcrypt
        const hashedSalt = await generateHashedSalt(salt);
        // Combine hashedPassword (from user) with hashed salt and hash again
        const combinedHash = await bcrypt.hash(hashedPassword, hashedSalt);
        // Create a new user with Prisma, storing the combined hash
        const user = await prisma.user.create({
            data: {
                sub,
                hashedPassword: combinedHash, // Store the combined hash
                salt: hashedSalt, // Store the hashed salt (for potential future use)
                xp: 10, // Optional initial experience points
            },
        });
        if (!user) {
            return res.status(400).json({ message: 'User creation failed' });
        }
        res.json({ message: 'User created successfully' });

    } catch (error) {
        console.log(error)
        res.status(500).json({ message: 'Internal server error' });
    }
} )


router.get('/salt', async (req, res) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
          return res.status(401).json({ message: 'Unauthorized' });
        }
    
        const token = authHeader.split(' ')[1];
        const decoded = jwtDecode(token);
    
        // Extract user identifier (e.g., from sub claim)
        const userId = decoded.sub;
    
        // Fetch user data from database using Prisma
        const user = await prisma.user.findUnique({
          where: { sub: userId },
        });
    
        if (!user) {
          return res.status(404).json({ message: 'User not found' });
        }


        res.status(200).json({salt: user.salt});
    
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
})

export default router;