# Downloading Mainframe IBM call records using Container

Container is built using an openconnect container as its base then adds lftp and opens connection by default then transferring all files from the mainframe directory to the mounted host directory in the container.

All variables should be set in a `.env.ovpn` file an example of this file is provided as `.env.ovpn.sample` simply.

**NOTE**: Take note of the comments in .env.ovpn to see how to reset the FTP password that is required every 60 days. Information is in 1password about this.

```bash
# .env.ovpn is default ignored in project.
cp -p .env.ovpn.sample .env.ovpn
vi .env.ovpn
```

Once you have the .env.ovpn file available you can build the container and run it with the following command. As mentioned it will connect to the vpn server then issue the lftp commands to download all new records not present in the mounted host records directory.

```bash
# Create the records directory.
# ./records is Default ignored in project
mkdir -p ./records
# Run script ensuring appropriate values are set in .env.ovpn so it can create the appropriate docker run command and execute.
# Provide secureid token after -s and -d enables debug so you can see the full docker command ran.
bin/getrecords -d -s 132414
```

To build the container locally instead of allowing it to pull from [sdunixgeek/attocvpn](https://hub.docker.com/repository/docker/sdunixgeek/attocvpn) on docker hub do the following:

Build for local machine

```bash
docker build -f Dockerfile -t  sdunixgeek/attocvpn .
```

Buildx for multi-arch

```bash
# Create buildx instance and use
docker buildx create --name attocvpn --use
# Create build and push for arm64 and amd64 ti sdunixgeek
docker buildx build --platform linux/arm/v7,linux/arm64,linux/amd64 -t sdunixgeek/attocvpn:latest . --push
# Remove buildx instance once done
docker buildx rm attocvpn
```
## Troubleshoot

Below are some common issues and how to address them.

### Error in the certificate

If when attempting to connect to the openconnect endpoint you receive a certificate error like this

```
Starting openconnect VPN client...
Using serverCert sha256:snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje...
None of the 1 fingerprint(s) specified via --servercert match server's certificate: pin-sha256:snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje
SSL connection failure: Error in the certificate.
Failed to open HTTPS connection to somehost.example.exmpl.com
Failed to complete authentication
```

Then you should

First grab the fingerprint for the server using your local cli `sha256:xr119o3xwqdnd9bvhd88n8t8fzeh9fmr1xwq5c1wbjji` in the example output below

command
```bash
gnutls-cli --insecure somehost.example.exmpl.com
```
output
```bash
Processed 0 CA certificate(s).
Resolving 'somehost.example.exmpl.com:443'...
Connecting to '101.70.158.164:443'...
- Certificate type: X.509
- Got a certificate list of 1 certificates.
- Certificate[0] info:
 - subject `CN=somehost.example.exmpl.com,O=Random Services\, Inc.,L=Dallas,ST=Texas,C=US', issuer `CN=DigiCert TLS RSA SHA256 2020 CA1,O=DigiCert Inc,C=US', serial snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje, RSA key 2048 bits, signed using RSA-SHA256, activated `2022-08-17 00:00:00 UTC', expires `2023-08-24 23:59:59 UTC', pin-sha256="snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje="
	Public Key ID:
		sha1:snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje
		sha256:xr119o3xwqdnd9bvhd88n8t8fzeh9fmr1xwq5c1wbjji
	Public Key PIN:
		pin-sha256:snfovo22zzcmrsdecdwtpl9aww3z4t3kmbxfyoldec13gteje

- Status: The certificate is NOT trusted. The certificate issuer is unknown.
*** PKI verification of server certificate failed...
- Description: (TLS1.2-X.509)-(RSA)-(AES-256-CBC)-(SHA1)
- Session ID: 84:21:2C:29:C7:1C:70:D6:D7:F7:35:E3:C0:99:D9:52:5F:C8:AD:D8:A0:51:43:DF:13:27:30:88:CC:86:F7:B6
- Options: safe renegotiation,
- Handshake was completed

- Simple Client Mode:
```

Then add that to your .env.ovpn as the following

```
oc_serverCert=sha256:xr119o3xwqdnd9bvhd88n8t8fzeh9fmr1xwq5c1wbjji
```

Then try again.

## Example Output

```text
bin/getrecords -d -s 132414
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
