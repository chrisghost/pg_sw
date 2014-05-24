PostgreSQL version switcher for MacOS
=====================================

Launch and stop different postgresql versions easily

Dependency : brew

Note: I am assuming postgres's are installed in : /usr/local/var/postgres*

Supported formulas : postgresql8, postgresql9x

Usage: ``pg -h`` (ou https://github.com/chrisghost/pg_sw/blob/master/pg_sw.sh#L17-L25)

Example : ``pg 8.4`` Stop current postgresql server, unlink it, link 8.4 and launch it
