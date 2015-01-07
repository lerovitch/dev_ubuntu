# dev_ubuntu

## Requirements

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)


## Installing 

```
  $ vagrant up
```

## Working with the host

* *user*: developer *pwd*: developer

## Job Configuration 

### Python version

Python is installed using [pyenv](https://github.com/yyuu/pyenv). 

There is a virtualenv *nlp* which has all the python dependencies installed.


### PyCharm configuration

1. Configure a new project with Python interpreter pointing at: `~/.pyenv/versions/nlp`

2. Running configurations:

* *Script*: /home/developer/.pyenv/versions/nlp/bin/twistd
* *Script Parameters*: --pidfile=bls.pid -r epoll --logger=befogg_logging.logger.twisted_python_logger_observer -n befogg_console


 
