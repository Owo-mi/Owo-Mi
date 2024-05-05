import { Router } from "express"
import { prisma } from "../config/prisma/Prismaclient"

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

export default router;