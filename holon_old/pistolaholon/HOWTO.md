# How to run Pistola

## Linux

```bash
./pistolaholon --destConfigFile=/home/jeffprestes/projetos/holon.extension.boilerplate/app/config/abi.json --stage=10 --zueira
```

## Windows

```bash
pistolaholon.exe --destConfigFile=/home/jeffprestes/projetos/holon.extension.boilerplate/app/config/abi.json --stage=1 --zueira
```

## Como compilar para windows de um Ubuntu

```bash
GOOS=windows GOARCH=amd64 go build -o pistolamock.exe
```
