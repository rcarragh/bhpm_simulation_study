#!/bin/bash

#R -q --no-save <<! &
#source("run1a.hier3.lev0.r")
#!
#
#R -q --no-save <<! &
#source("run1a.hier3.lev1.r")
#!

R -q --no-save <<! &
source("run1a.hier3.cluster.lev0.r")
!

R -q --no-save <<! &
source("run1a.hier3.cluster.lev1.r")
!

wait
