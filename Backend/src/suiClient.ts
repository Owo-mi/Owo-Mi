import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';

const network = 'testnet';
const fullnodeUrl = getFullnodeUrl(network);

// create a SuiClient instance
const client = new SuiClient({ url: fullnodeUrl });

export default client;
