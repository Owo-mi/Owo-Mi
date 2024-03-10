# OWO MI

## BACKEND
```dir: owomi/api```
1. Create virtual environment ```python3 -m venv .venv```  and install requirements.txt. ```pip install requirements.txt```


## Installing Doppler

We use Doppler to centrally manage our backend secrets. When we start the backend server, the Doppler CLI retrieves the latest secrets and injects them into the process as environment variables.

> You will need to request access to the [Doppler team](https://dashboard.doppler.com/workplace/8de8a8f6e6b4e48d28bb/projects) before proceeding

Install the [Doppler CLI](https://docs.doppler.com/docs/install-cli).

### macOS - Using [brew](https://brew.sh/)
```shell
$ brew install gnupg

$ brew install dopplerhq/cli/doppler
```

### Windows - Using [scoop](https://scoop.sh/)
```shell
$ scoop bucket add doppler https://github.com/DopplerHQ/scoop-doppler.git

$ scoop install doppler
```

### Windows - Using [Git Bash](https://gitforwindows.org/)
```shell
$ mkdir -p $HOME/bin

$ curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sh -s -- --install-path $HOME/bin
```

Ensure you have Doppler installed using `doppler --version` and update to the latest version using `doppler update`.

### Login to Doppler

Login using `doppler login`.

![Doppler Login](assets/doppler-login.gif)

### Configure Doppler

Configure using `doppler setup`.

![Doppler Setup](assets/doppler-setup.gif)

2. Run ```./run.sh``` to enable .venv and start server.

