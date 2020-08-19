# Downloading Mainframe IBM call records using Container

Container is built using an openconnect container as its base then adds lftp and opens connection by default then transferring all files from the mainframe directory to the mounted host directory in the container.

All variables should be set in a `.env.docker` file an example of this file is provided as `.env.docker.sample` simply.

**NOTE**: Take note of the comments in .env.docker to see how to reset the FTP password that is required every 60 days. Information is in 1password about this.

```bash
# .env.docker is default ignored in project.
cp -p .env.docker.sample .env.docker
vi .env.docker
```

Once you have the .env.docker file available you can build the container and run it with the following command. As mentioned it will connect to the vpn server then issue the lftp commands to download all new records not present in the mounted host records directory.

```bash
# Create the records directory.
# ./records is Default ignored in project
mkdir -p ./records
# Run container specifying .env.docker file for secretes and variables.
docker run -it --rm \
  --privileged -w /records \
  -v $(pwd)/records:/records \
  --env-file .env.docker \
  sdunixgeek/attocvpn
```

To build the container locally instead of allowing it to pull from [sdunixgeek/attocvpn](https://hub.docker.com/repository/docker/sdunixgeek/attocvpn) on docker hub do the following:

```bash
docker build -f Dockerfile -t  sdunixgeek/attocvpn .
```

## Example Output

```text
docker run -it --rm \
>   --privileged -w /records \
>   -v $(pwd)/records:/records \
>   --env-file .env.docker \
>   sdunixgeek/attocvpn
Starting openconnect VPN client...
Starting lftp transfer of all NEW files in specified directory G.AC.AFSD
Failed to read from SSL socket: The transmitted packet is too large (EMSGSIZE).
Failed to recv DPD request (1406)
grep: /etc/nsswitch.conf: No such file or directory
grep: /etc/nsswitch.conf: No such file or directory
Connect Banner:
| Warning: This system is restricted to ACME authorized users for
| business purposes. Unauthorized access is a violation of the law.
| This service may be monitored for administrative and security
| value reasons. By proceeding, you consent to this monitoring.
|

Completed lftp transfer of all NEW files in specified directory G.AC.AFSD
lcd ok, local cwd=/records
cd ok, cwd='AND521.'/'G.AC.AFSD'
Transferring file `F1962.R00'
Transferring file `F1963.R00'
Transferring file `F1964.R00'
Transferring file `F1965.R00'
Transferring file `F1966.R00'
Transferring file `F1967.R00'
Transferring file `F1968.R00'
Transferring file `F1969.R00'
Finished transfer `F1964.R00' (69.7 KiB/s)
Transferring file `F1970.R00'
Finished transfer `F1968.R00' (70.4 KiB/s)
Transferring file `F1971.R00'
Finished transfer `F1969.R00' (70.0 KiB/s)
Transferring file `F1972.R00'
Finished transfer `F1965.R00' (74.3 KiB/s)
Transferring file `F1973.R00'
Finished transfer `F1962.R00' (84.2 KiB/s)
Transferring file `F1974.R00'
Finished transfer `F1963.R00' (80.6 KiB/s)
Transferring file `F1975.R00'
Finished transfer `F1967.R00' (79.4 KiB/s)
Transferring file `F1976.R00'
Finished transfer `F1972.R00' (83.7 KiB/s)
Transferring file `F1977.R00'
Finished transfer `F1973.R00' (88.3 KiB/s)
Transferring file `F1978.R00'
Finished transfer `F1966.R00' (102.7 KiB/s)
Transferring file `F1979.R00'
Finished transfer `F1974.R00' (104.6 KiB/s)
Transferring file `F1980.R00'
Finished transfer `F1971.R00' (99.1 KiB/s)
Transferring file `F1981.R00'
Finished transfer `F1978.R00' (92.3 KiB/s)
Transferring file `F1982.R00'
Finished transfer `F1975.R00' (93.7 KiB/s)
Transferring file `F1983.R00'
Finished transfer `F1977.R00' (87.3 KiB/s)
Transferring file `F1984.R00'
Finished transfer `F1979.R00' (85.3 KiB/s)
Transferring file `F1985.R00'
Finished transfer `F1970.R00' (86.9 KiB/s)
Transferring file `F1986.R00'
Finished transfer `F1976.R00' (87.8 KiB/s)
Transferring file `F1987.R00'
Finished transfer `F1980.R00' (61.7 KiB/s)
Transferring file `F1988.R00'
Finished transfer `F1984.R00' (63.1 KiB/s)
Transferring file `F1989.R00'
Finished transfer `F1982.R00' (62.7 KiB/s)
Transferring file `F1990.R00'
Finished transfer `F1983.R00' (63.3 KiB/s)
Transferring file `F1991.R00'
Finished transfer `F1987.R00' (69.1 KiB/s)
Transferring file `F1992.R00'
Finished transfer `F1981.R00' (71.9 KiB/s)
Transferring file `F1993.R00'
Finished transfer `F1985.R00' (69.9 KiB/s)
Transferring file `F1994.R00'
Finished transfer `F1988.R00' (74.2 KiB/s)
Transferring file `F1995.R00'
Finished transfer `F1986.R00' (73.9 KiB/s)
Transferring file `F1996.R00'
Finished transfer `F1989.R00' (71.1 KiB/s)
Transferring file `F1997.R00'
Finished transfer `F1992.R00' (64.7 KiB/s)
Transferring file `F1998.R00'
Finished transfer `F1993.R00' (47.3 KiB/s)
Transferring file `F1999.R00'
Finished transfer `F1994.R00' (47.6 KiB/s)
Transferring file `F2000.R00'
Finished transfer `F1990.R00' (54.7 KiB/s)
Transferring file `F2001.R00'
Finished transfer `F1991.R00' (58.4 KiB/s)
Transferring file `F2002.R00'
Finished transfer `F1997.R00' (64.5 KiB/s)
Transferring file `F2003.R00'
Finished transfer `F1998.R00' (77.4 KiB/s)
Transferring file `F2004.R00'
Finished transfer `F1995.R00' (81.5 KiB/s)
Transferring file `F2005.R00'
Finished transfer `F1996.R00' (74.2 KiB/s)
Finished transfer `F1999.R00' (72.9 KiB/s)
Finished transfer `F2002.R00' (77.2 KiB/s)
Finished transfer `F2003.R00' (77.3 KiB/s)
Finished transfer `F2000.R00' (81.3 KiB/s)
Finished transfer `F2001.R00' (99.9 KiB/s)
Finished transfer `F2004.R00' (106.8 KiB/s)
Finished transfer `F2005.R00' (255.6 KiB/s)
New: 44 files, 0 symlinks
162230662 bytes transferred in 316 seconds (500.6 KiB/s)
```
