#!/bin/bash

#R -q --no-save <<! &
#source("runBB.hier3.lev0.r")
#!
#
#R -q --no-save <<! &
#source("runBB.hier3.lev1.r")
#!

R -q --no-save <<! &
source("runBB.hier3.cluster.lev0.r")
!

R -q --no-save <<! &
source("runBB.hier3.cluster.lev1.r")
!

wait
