create.patient.data <- function(N, patient.dist.file = "PATIENT.DIST", cluster.avg.time.file = "CLUSTER.AVERAGE.TIME", treat.all = "TREATMENT.ALLOC")
{
	data = read.table(patient.dist.file, header = TRUE)

	N.C <- as.integer(N*data$p)
	N.C[ length(N.C) ] <- N - sum(N.C[1:(length(N.C) - 1)])

	c.a.t <- read.table(cluster.avg.time.file, header = TRUE)
	t.a <- read.table(treat.all, header = TRUE)

	list.pats <- list()

	for (i in 1:nrow(c.a.t)) {
		avg.time <- c.a.t[i,]
		exposure.times <- rnorm(N.C[i], avg.time$average.duration, 10)
		t.a.c <- t.a[ t.a$Cluster == c.a.t[i,]$Cluster,]
		prop <- as.integer(N.C[i]*t.a.c$p)
		prop[length(prop)] <- N.C[i] - sum(prop[1:(length(prop) - 1)])
		list.pats[[i]] <- data.frame(Cluster = rep(avg.time$Cluster, N.C[i]), Treatment = rep(1:4, prop), Exposure = exposure.times)
	}

	patients <- do.call("rbind", list.pats)

	patients$id <- 1:N

	patients <- patients[,c(ncol(patients),1:(ncol(patients)-1))]

	write.table(patients, "PATIENTS.DAT")
}

#N = 14000 ## approximate size of the population

#create.patient.data(N)
