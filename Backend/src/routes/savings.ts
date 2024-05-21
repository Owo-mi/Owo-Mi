import { Router } from "express"
// import { prisma } from "../config/prisma/Prismaclient" // not sure if savings feature is store in backend //
import { Request, Response } from "express";

const router = Router();

router.get('/test', async (req, res) => {
    return res.json({ savings: true });
});

export default router;