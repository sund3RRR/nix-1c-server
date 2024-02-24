# nix-1c-server

Проект стремится создать декларативную конфигурацию для 1С серверов.

## Установка
### В качестве модуля NixOS

#### **`/etc/nixos/configuration.nix`**

```nix
{ config, pkgs, lib,... }:  
let  
 server-1c = builtins.fetchTarball {  
   url = "https://github.com/sund3RRR/nix-1c-server/archive/412507cf4b58e3174ab17e4d78cb13bbdd046645.tar.gz";  
   sha256 = "sha256:07c7wla0pmg2j1mwdv2ga7jza505rbvghmx5bximsfnq0cairxcv";  
 };
in
{
  imports = [
    ./hardware-configuration.nix
    server-1c 
  ];
  # The rest of your configuration.nix file
  ...
```

### Flake
WIP
## Использование
### Подготовка
:warning: Модуль не предоставляет никакие установочные файлы 1С сервера :warning:

Вам необходимо авторизоваться на сайте https://releases.1c.ru/total, выбрать версию, скачать дистрибутив **Сервер 1С:Предприятия (64-bit) для DEB-based Linux-систем** и распаковать `.tar.gz` архив с `.deb` пакетами в любую папку (поддержка установщиков `.run` [возможно](https://github.com/sund3RRR/nix-1c-server?tab=readme-ov-file#Ограничения) появится позже).
### Настройка
  1. Укажите путь до каталога с `.deb` пакетами 1С сервера в поле `sourceDir`
  ```nix
    server-1c = {
      sourceDir = /home/sunder/Downloads/deb64_8_3_24_1368/;
    };
  ```
  2. Создайте `instance`
  ```nix
    server-1c = {
      sourceDir = /home/sunder/Downloads/deb64_8_3_24_1368/;
      instances = {
        "main" = {
          enable = true;
          version = "8.3.24.1368";
          # Модуль фильтрует .deb пакеты на основе версии,
          # так что вы можете хранить все версии в одном каталоге
        };
      };
    };
  ```
  3. Настройте в соответствии с [опциями](docs/docs.md)
  ```nix
    server-1c = {
      sourceDir = /home/sunder/dev/1c-server/pkgs/1c-server/src;
      instances = {
        "main" = {
         enable = true;
         version = "8.3.24.1368";
           services.standalone-server = {
             enable = true;
             openFirewall = true;
             settings = {
               http.enable = true;
               name = "main";
               data = "/var/lib/usr1cv8/.1cv8/1C/1cv8/standalone-server/";
             };
           };
         };
       };
     };
  ```
## Примеры
Вы можете посмотреть примеры использования в папке [example](https://github.com/sund3RRR/nix-1c-server/tree/main/example)

## Ограничения

- Поддерживается установка только из `.deb`. Установщик `.run` в данный момент не представляется возможным запустить нативно на NixOS, поскольку перед запуском необходимо пропатчить ELF раздел, однако бинарник проверяет свою целостность при запуске, поэтому отказывается распаковывать архив, увидев несовпадение хэш сумм.
- PostgreSQL для 1С пока что не поддерживается, но в планах
