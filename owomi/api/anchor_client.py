from pathlib import Path
import json
from solders.pubkey import Pubkey
from anchorpy import Idl, Program
from anchorpy.provider import Provider
from decouple import config


async def create_program_client():
    idl_path = '../../idl.json'
    with Path(idl_path, "r") as idl_file:
        idl_json = idl_file.read()
    idl = Idl.from_json(idl_json)
    # Mount this to the doppler
    program_id = Pubkey.from_string("CAExaUGyDw6HR93CuXipA2oXTf1QGnGpxeWSAJjFQx7p")
    provider = Provider(connection='https://api.devnet.solana.com')
    program =  Program(idl, program_id, provider)
    return program


