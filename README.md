sfr-neufbox-change-ip
=====================

A little script to change the IP address of your internet connexion

Requirements
------------

This script works with my SFR Neufbox Evolution.

We suppose that the box is accessible at `192.168.1.1` (you can modify the script to set a custom IP address).

Usage
-----

### Retrieve dependency

First in order to retrieve needed dependency, run:
```
    make
```

### Configuration

You need to create a file `.credentials` with the following format:
```
    login:password
```
These credentials are the same you are using to connect on the web interface of you Neufbox.

### Run

Just run the script to change the external IP address of your internet connexion.

Dependency
-----

This script is using PhantomJS (http://phantomjs.org/).



