sfr-neufbox-change-ip
=====================

A little script to change the IP address of your internet connexion

Requirements
------------

This script works with my SFR Neufbox Evolution.
We suppose that the box is accessible at `192.168.1.1`. You can modify the script to set a custom IP address.

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

### Run

Just run the script to change the external IP address of your internet connexion.
