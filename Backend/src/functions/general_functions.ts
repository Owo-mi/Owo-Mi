import * as bcrypt from 'bcrypt';


export const generateHashedSalt = async (salt: string): Promise<string> => {
    const hashedSalt = await bcrypt.hash(salt, 10);

    return hashedSalt

}

