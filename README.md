[![Docker Repository on Quay](https://quay.io/repository/thwint/bind/status "Docker Repository on Quay")](https://quay.io/repository/thwint/bind)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)
# Dockerized DNS server
Bind DNS server running in a Docker container. 
## Configuration
Zone configuration file has to be placed in /etc/bind/named.conf.local

Sample zone configuration file (named.conf.local):

    zone "example.com" IN {
	    type master;
	    file "/var/bind/pri/example.com.zone";
    };

Zone files have to be mounted in /var/bind/pri

Sample zone file (example.com.zone):

    $TTL 1h
    @ IN SOA ns1.example.com contact.example.com. (
                2018020400      ; Serial
                1h              ; Refresh
                15m             ; Retry
                1d              ; Expire
                1h );           ; Negative Cache TTL
    example.com.        1800    IN    NS        ns1.example.com.
    ns1                 1800    IN    A         1.2.3.4
    www                 1800    IN    A         1.2.3.5
    webmail             3600    IN    CNAME     www.example.com.

Many options can be configured using environment variables

    Variable name           Defaultvalue        Description
    =============           ============        ===========
    ALLOW_QUERY             any                 Specifies which hosts are allowed to ask ordinary DNS questions
    ALLOW_TRANSFER          none                Specifies which hosts are allowed to receive zone transfers from the server
    CLIENTS_PER_QUERY       0                   Set the minimum value of recursive simultaneous clients for any given query
    DNSSEC_ENABLE           no                  Enable DNSSEC support
    DNSSEC_VALIDATION       no                  Enable DNSSEC validation
    ENABLE_IPV6             false               Listen on IPv6
    FORWARDERS              8.8.8.8; 8.8.8.4;   Specifies the IP addresses to be used for forwarding
    MAX_CACHE_SIZE          100M                The maximum amount of memory to use for the server's cache
    MAX_CACHE_TTL           60                  Set a maximum retention time for negative answers
    MAX_NCACHE_TTL          60                  Set a maximum retention time for positive answers
    MAX_CLIENTS_PER_QUERY   0                   Set the minimum value of recursive simultaneous clients for any given query

## Update running containers
To update modified bind configuration the container has to be restarted or the corresponding rndc command has to be run 
inside the container. 
### New zones
To add new zones the nameserver needs to be reconfigured.

    rndc reconfigure

### Modified zones
Modified zones have to be reloaded. 

    rndc reload <zone>
    
    Example:
    rndc reload google.com

## run
### docker-compose.yaml
    version: '2.1'
    services:
      bind:
        image: quay.io/thwint/bind:latest
        container_name: bind
        hostname: bind
        environment:
          ENABLE_IPV6: true
        volumes:
          - /data/bind/master:/var/bind/pri
          - /data/bind/named.conf.local:/etc/bind/named.conf.local
