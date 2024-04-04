from pathlib import Path
import json
from solders.pubkey import Pubkey
from anchorpy import Idl, Program
from anchorpy.provider import Provider
from decouple import config

DEV_NET_KEY = config('DEV_NET_KEY')

async def create_program_client():
    idl_path = '../../idl.json'
    with Path(idl_path, "r") as idl_file:
        idl_json = idl_file.read()
    idl = Idl.from_json(idl_json)
    # Mount this to the doppler
    program_id = Pubkey.from_string(DEV_NET_KEY)
    provider = Provider(connection='https://api.devnet.solana.com')
    program =  Program(idl, program_id, provider)
    return program


