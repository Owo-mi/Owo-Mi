from pathlib import Path
import json
from solders.pubkey import Pubkey
from solana.rpc.async_api import AsyncClient
from anchorpy import Idl, Program, Wallet
from anchorpy.provider import Provider
from decouple import config

DEV_NET_KEY = config('DEV_NET_KEY')
DEV_NET_URL = config('DEV_NET_URL')

async def create_program_client():
    client = AsyncClient('DEV_NET_URL')
    idl_path = '../../idl.json'
    with Path(idl_path, "r") as idl_file:
        idl_json = idl_file.read()
    idl = Idl.from_json(idl_json)
    # Mount this to the doppler
    program_id = Pubkey.from_string(DEV_NET_KEY)
    provider = Provider(connection=DEV_NET_URL)
    program =  Program(idl, program_id, provider)
    return program


