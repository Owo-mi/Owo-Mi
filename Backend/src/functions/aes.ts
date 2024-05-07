import CryptoJS = require('crypto-js'); // Use require syntax for CryptoJS
import "dotenv/config";

const key = process.env.ENCRYPTION_KEY || '';

console.log(key);

export const encrypt = async (salt: string) => {
    const saltWordArray = CryptoJS.enc.Utf8.parse(salt);
    const encryptedData = CryptoJS.AES.encrypt(saltWordArray, key);
    return encryptedData;
}

export const decrypt = async (cipher: object) => {
    try {
        let bytes = CryptoJS.AES.decrypt(cipher.toString(), key);
        if (bytes.sigBytes === 0) {
            throw new Error('Decryption failed');
        }
        const salt = bytes.toString(CryptoJS.enc.Utf8);
        return salt;
    } catch (error) {
        console.error("Decryption error:", error);
        throw error; // Rethrow the error to handle it elsewhere if needed
    }
}
