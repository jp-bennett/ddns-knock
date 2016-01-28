# ddns-knock
Set of scripts that use fwknop to power a ddns service for a single domain.

Start by generating the key in your named directory:
dnssec-keygen -a hmac-sha512 -b 512 -n HOST <mydomain>

Grab the key from the created file: K<mydomain>*.private and add a key section to your named.conf:

key <mydomain> {
        algorithm hmac-sha512;
        secret "<KEY string from the .private file>";
};

And add a line to the zone stanza for your domain:
allow-update { key <mydomain>; };

fill your domain name into the two scripts, and copy them both to /usr/local/bin.

At this point, running add-dnsknock.sh <newhostname> will add the proper lines to your fwknopd access.conf file
and generate an fwknop command that should update that new hostname.
