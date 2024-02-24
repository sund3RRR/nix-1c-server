## server-1c\.instances



Attribute set of instances\. Key is the instance label, value is the settings\.



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.enable



Whether to enable this instance\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.programs



Programs provided by this module



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.programs\.ibcmd



Console server management utility



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.programs\.ibcmd\.enable



Whether to enable ibcmd\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.programs\.ibsrv



Server entrypoint program



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.programs\.ibsrv\.enable



Whether to enable ibsrv\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services



Instance services configuration



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server



Main server service



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.enable



Whether to enable main server service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.openFirewall



Whether to open ports in firewall



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings



Settings for main server service



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.data



Path to directory with cluster data



*Type:*
string



*Default:*
` "/var/lib/usr1cv8/.1cv8/1C/1cv8" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.debug



1C:Enterprise server configuration debug mode
DEBUG off: empty (default)
TCP    on: -debug or “-debug -tcp”
HTTP   on: “-debug -http”



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.extraArgs



Extra command line arguments for server



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.pingPeriod



Check period for connection loss detector, milliseconds



*Type:*
signed integer



*Default:*
` 1000 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.pingTimeout



Response timeout for connection loss detector, milliseconds



*Type:*
signed integer



*Default:*
` 5000 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.port



Cluster agent main port



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` 1540 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.portRange



Port range for connection pool



*Type:*
string



*Default:*
` "1560:1591" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.regPort



Cluster main port for default cluster



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` 1541 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.full-server\.settings\.securityLevel



0 - default - unprotected connections
1 - protected connections only for the time of user authentication
2 - permanently protected connections



*Type:*
signed integer



*Default:*
` 0 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server



Standalone server service



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.enable



Whether to enable standalone server\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.openFirewall



Whether to open ports in firewall



*Type:*
boolean



*Default:*
` false `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings



Standalone server settings



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.data



Path to the server data directory\.



*Type:*
string



*Default:*
` "/var/lib/usr1cv8/.1cv8/1C/1cv8/standalone-server/" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.debug-port



TCP port used by the debug server over HTTP



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` 1550 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.direct-range



Port range used to establish direct server connection



*Type:*
string



*Default:*
` "1560:1591" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.direct-regport



Primary port used to establish direct server connection



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` 1541 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.extraArgs



Extra command line arguments for server



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.http



HTTP settings



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.http\.enable



Prohibit access to the standalone server via HTTP



*Type:*
boolean



*Default:*
` true `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.http\.port



Main TCP port used by the server\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*
` 8314 `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.services\.standalone-server\.settings\.name



Infobase name\.
By default, an infobase ID string presentation is used



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.instances\.\<name>\.version



Version of 1C server instance



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)



## server-1c\.sourceDir



Directory with 1C source \.deb packages



*Type:*
path or string



*Default:*
` "" `

*Declared by:*
 - [/modules/options\.nix](https://github.com/sund3RRR/nix-1c-server/blob/main/modules/options.nix)


