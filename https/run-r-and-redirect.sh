#!/bin/sh


service apache2 restart
cd /src
Rscript main.R

