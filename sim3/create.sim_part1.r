nSims = 1000
#nSims = 500
#nSims = 10

seed <- read.table("sim.seed.dat")
set.seed(seed$V1)

scripts.dir <- "/home/clb13102/SIPBs/bhpm_model_paper/simulation_study/scripts"

init.sim = sprintf("%s/%s", scripts.dir, "init.sim.data.r")
create.patients = sprintf("%s/%s", scripts.dir, "create.patient.data.r")
gen.events = sprintf("%s/%s", scripts.dir, "gen.events.r")

T = 4
C = 10
p = c(0.025, 0.05, 0.05, .1, .1, .1, .1, .1, .175, .2)

source(init.sim)
create.lambda(C, T, outcomes = "../OUTCOMES", r = 0.001, sd = 0.0001)
create.patient.dist(C, p)
p = c(.2,.2,.2,.4)
p1 = rep(p, C/2)
p2 = rep(0.25, T * C/2)
p = c(p1, p2)
create.treatment.alloc(C, T, p)
