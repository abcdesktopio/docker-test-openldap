[![Docker Image CI](https://github.com/abcdesktopio/docker-test-openldap/actions/workflows/docker-image.yml/badge.svg)](https://github.com/abcdesktopio/docker-test-openldap/actions/workflows/docker-image.yml)

# OpenLDAP Docker Image for testing

This Docker image provides an OpenLDAP Server for testing LDAP applications, i.e. unit tests. The server is initialized with the example domain `planetexpress.com` with data from the [Futurama Wiki][futuramawikia].

Parts of the image are based on the work from Nick Stenning [docker-slapd][slapd] and Bertrand Gouny [docker-openldap][openldap].

The Flask extension [flask-ldapconn][flaskldapconn] use this image for unit tests.

[slapd]: https://github.com/nickstenning/docker-slapd
[openldap]: https://github.com/osixia/docker-openldap
[flaskldapconn]: https://github.com/rroemhild/flask-ldapconn
[futuramawikia]: http://futurama.wikia.com


## Features

* Initialized with data from Futurama
* Support for LDAP over TLS (STARTTLS) using a self-signed cert, or valid certificates (LetsEncrypt, etc)
* memberOf overlay support
* MS-AD style groups support
* Supports Forced STARTTLS 
* Supports custom domain and custom directory structure


## Usage

```
docker pull ghcr.io/rroemhild/docker-test-openldap:master
docker run --rm -p 10389:10389 -p 10636:10636 ghcr.io/rroemhild/docker-test-openldap:master
```

## Testing

```
# List all Users
ldapsearch -H ldap://localhost:10389 -x -b "ou=people,dc=planetexpress,dc=com" -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone "(objectClass=inetOrgPerson)"

# Request StartTLS
ldapsearch -H ldap://localhost:10389 -Z -x -b "ou=people,dc=planetexpress,dc=com" -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone "(objectClass=inetOrgPerson)"

# Enforce StartTLS
ldapsearch -H ldap://localhost:10389 -ZZ -x -b "ou=people,dc=planetexpress,dc=com" -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone "(objectClass=inetOrgPerson)"

# Enforce StartTLS with self-signed cert
LDAPTLS_REQCERT=never ldapsearch -H ldap://localhost:10389 -ZZ -x -b "ou=people,dc=planetexpress,dc=com" -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone "(objectClass=inetOrgPerson)"
```

## Exposed ports

* 10389 (ldap)
* 10636 (ldaps)

## Exposed volumes

* /etc/ldap/slapd.d
* /etc/ldap/ssl
* /var/lib/ldap
* /run/slapd


## LDAP structure

### changes for abcdesktop.io

abcdesktop.io adds the poxicAccount support. To do that, we add for each user 

```
objectClass: posixAccount
```

and attributs 

```
uidNumber
gidNumber
homeDirectory
```
with dedicated values.

### dc=planetexpress,dc=com

| Admin            | Secret           |
| ---------------- | ---------------- |
| cn=admin,dc=planetexpress,dc=com | GoodNewsEveryone |

### ou=people,dc=planetexpress,dc=com

#### cn=Hubert J. Farnsworth,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Hubert J. Farnsworth |
| sn               | Farnsworth |
| description      | Human |
| displayName      | Professor Farnsworth |
| employeeType     | Owner |
| employeeType     | Founder |
| givenName        | Hubert |
| jpegPhoto        | JPEG-Photo (630x507 Pixel, 26780 Bytes) |
| mail             | professor@planetexpress.com |
| mail             | hubert@planetexpress.com |
| ou               | Office Management |
| title            | Professor |
| uid              | professor |
| userPassword     | professor |
| uidNumber	       | 2045 |
| gidNumber        | 12045 |
| homeDirectory:   | /home/professor |


### cn=Philip J. Fry,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Philip J. Fry |
| sn               | Fry |
| description      | Human |
| displayName      | Fry |
| employeeType     | Delivery boy |
| givenName        | Philip |
| jpegPhoto        | JPEG-Photo (429x350 Pixel, 22132 Bytes) |
| mail             | fry@planetexpress.com |
| ou               | Delivering Crew |
| uid              | fry |
| userPassword     | fry |
| uidNumber	       | 2042 |
| gidNumber        | 12042 |
| homeDirectory:   | /home/fry |

### cn=John A. Zoidberg,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | John A. Zoidberg |
| sn               | Zoidberg |
| description      | Decapodian |
| displayName      | Zoidberg |
| employeeType     | Doctor |
| givenName        | John |
| jpegPhoto        | JPEG-Photo (343x280 Pixel, 26438 Bytes) |
| mail             | zoidberg@planetexpress.com |
| ou               | Staff |
| title            | Ph. D. |
| uid              | zoidberg |
| userPassword     | zoidberg |
| uidNumber	       | 2047 |
| gidNumber        | 12047 |
| homeDirectory:   | /home/zoidberg |

### cn=Hermes Conrad,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Hermes Conrad |
| sn               | Conrad |
| description      | Human |
| employeeType     | Bureaucrat |
| employeeType     | Accountant |
| givenName        | Hermes |
| mail             | hermes@planetexpress.com |
| ou               | Office Management |
| uid              | hermes |
| userPassword     | hermes |
| uidNumber        | 2043 |
| gidNumber        | 12043 |
| homeDirectory    | /home/hermes |

### cn=Turanga Leela,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Turanga Leela |
| sn               | Turanga |
| description      | Mutant |
| employeeType     | Captain |
| employeeType     | Pilot |
| givenName        | Leela |
| jpegPhoto        | JPEG-Photo (429x350 Pixel, 26526 Bytes) |
| mail             | leela@planetexpress.com |
| ou               | Delivering Crew |
| uid              | leela |
| userPassword     | leela |
| uidNumber        | 2044 |
| gidNumber        | 12044 |
| homeDirectory    | /home/leela |

### cn=Bender Bending Rodríguez,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Bender Bending Rodríguez |
| sn               | Rodríguez |
| description      | Robot |
| employeeType     | Ship's Robot |
| givenName        | Bender |
| jpegPhoto        | JPEG-Photo (436x570 Pixel, 26819 Bytes) |
| mail             | bender@planetexpress.com |
| ou               | Delivering Crew |
| uid              | bender |
| userPassword     | bender |
| uidNumber        | 2046 |
| gidNumber        | 12046 |
| homeDirectory    | /home/bender |

### cn=Amy Wong+sn=Kroker,ou=people,dc=planetexpress,dc=com

Amy has a multi-valued DN

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| objectClass      | posixAccount |
| cn               | Amy Wong |
| sn               | Kroker |
| description      | Human |
| givenName        | Amy |
| mail             | amy@planetexpress.com |
| ou               | Intern |
| uid              | amy |
| userPassword     | amy |
| uidNumber        | 2048 |
| gidNumber        | 12048 |
| homeDirectory    | /home/amy |

### cn=admin_staff,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | Group |
| cn               | admin_staff |
| member           | cn=Hubert J. Farnsworth,ou=people,dc=planetexpress,dc=com |
| member           | cn=Hermes Conrad,ou=people,dc=planetexpress,dc=com |

### cn=ship_crew,ou=people,dc=planetexpress,dc=com

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | Group |
| cn               | ship_crew |
| member           | cn=Turanga Leela,ou=people,dc=planetexpress,dc=com |
| member           | cn=Philip J. Fry,ou=people,dc=planetexpress,dc=com |
| member           | cn=Bender Bending Rodríguez,ou=people,dc=planetexpress,dc=com |


## JAAS configuration

In case you want to use this OpenLDAP server for testing with a Java-based
application using JAAS and the `LdapLoginModule`, here's a working configuration
file you can use to connect.

```
other {
  com.sun.security.auth.module.LdapLoginModule REQUIRED
    userProvider="ldap://localhost:10389/ou=people,dc=planetexpress,dc=com"
    userFilter="(&(uid={USERNAME})(objectClass=inetOrgPerson))"
    useSSL=false
    java.naming.security.principal="cn=admin,dc=planetexpress,dc=com"
    java.naming.security.credentials="GoodNewsEveryone"
    debug=true
    ;
};
```

This config uses the admin credentials to connect to the OpenLDAP server and to
submit the search query for the user that enters their credentials. As username
the `uid` attribute of each entry is used.
