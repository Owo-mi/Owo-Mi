# OWO MI

## BACKEND
```dir: Backend/src``` **run the following commands in this directory.
1. Install dependencies ```npm install```


2. Setup Doppler CLI, then run `doppler secrets download --no-file --format env > .env` to mount env variables from doppler.

3.  Run ```npm run devStart``` to start server.

4. Directory ```dir: Backend/src``` run this `npx prisma db push` to update/push state to the database. 