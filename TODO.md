# TODO

Future enhancements, in no particular order:

## Remove the dependency on curl

I am working on a program that does simple downloading from http and
https sources that uses only resources available in a base OpenBSD
installation.

It's not stable enough to use yet, though. See
```develop/httpdl.pl``` for details.

## Add pledge and unveil

They are not available for shell scripts at the moment, and may not ever be.
