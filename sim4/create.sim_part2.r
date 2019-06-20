#nSims = 500
nSims = 1000
#nSims = 10
#nSims = 5

scripts.dir <- "/home/clb13102/SIPBs/bhpm_model_paper/simulation_study/scripts"

create.patients = sprintf("%s/%s", scripts.dir, "create.patient.data.r")
gen.events = sprintf("%s/%s", scripts.dir, "gen.events.r")

T = 4
C = 10
#p = 0.1

source(create.patients)
N = 14000

source(gen.events)

wd <- getwd()

for (s in 1:nSims) {

	dir <- sprintf("%s/%d", wd, s)
	dir.create(dir)
	setwd(dir)

	create.patient.data(N, patient.dist.file = "../PATIENT.DIST", cluster.avg.time.file = "../../CLUSTER.AVERAGE.TIME", treat.all = "../TREATMENT.ALLOC")

	generate.events(lambda.file = "../LAMBDA")
	summerise.events()

	setwd(wd)
}
