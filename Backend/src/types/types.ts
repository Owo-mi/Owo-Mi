import { Request } from "express";
import { JwtPayload } from "jwt-decode";

export interface  IdeCode extends JwtPayload {
    sub?: string;
    nonce?: string;
    email?: string;
}

export interface RequestWithUserRole extends Request {
    user?: IdeCode,
}