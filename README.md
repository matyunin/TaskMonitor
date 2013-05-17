TaskMonitor
===========
Enterprise solution for dynamic priority management of tasks.

[View requirements](REQUIREMENTS.md)

## Initializing

### Prepare environment

Go to folder where you want TaskMonitor to be placed and clone this git repository

```console
cd /var/www/
git clone git@github.com:matyunin/TaskMonitor.git
cd /var/www/TaskMonitor/
```

At first, you sould run [Bundler](https://github.com/carlhuda/bundler) to install all dependent gems:
```console
bundle install
```

### Start/stop service

>Note that TaskMonitor built on Debian Linux, and if you want to use this project on other linux distribution, 
>you should modify both `./run` and `./restart` scripts.

Use simple shell script `./run` in project directory to start TaskMonitor
```console
./run
```

When you want to restart service? use `./restart` shell script
```console
./restart
```
