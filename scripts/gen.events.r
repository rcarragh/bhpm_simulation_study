generate.events <- function(patients.file = "PATIENTS.DAT", lambda.file = "LAMBDA")
{
	patients <- read.table(patients.file, header = TRUE)
	lambda <- read.table(lambda.file, header = TRUE)

	patient.events <- merge(patients, lambda, by = c("Cluster", "Treatment"))

	events <- rpois(nrow(patient.events), lambda  = patient.events$Exposure * patient.events$rate)

	patient.events$events <- events

	write.table(patient.events, "EVENTS.dat")
}

summerise.events <- function(events.file = "EVENTS.dat")
{
	events <- read.table(events.file, header = TRUE)

	x = aggregate(events[, c("Exposure", "events")], by = list(Cluster = events$Cluster, Treatment = events$Treatment, Outcome.Grp = events$Outcome.Grp, Outcome = events$Outcome), sum)

	x$Cluster <- sprintf("Cluster%d", x$Cluster)
	names(x)[names(x) == "Treatment"] <- "Trt.Grp"
	names(x)[names(x) == "Outcome.Grp"] <- "Outcome.Grp"
	names(x)[names(x) == "Outcome"] <- "Outcome"
	names(x)[names(x) == "Exposure"] <- "Exposure"
	names(x)[names(x) == "events"] <- "Count"
	write.table(x, "SUMMARY_BY_CLUSTER.dat")

	x = aggregate(events[, c("Exposure", "events")], by = list(Treatment = events$Treatment, Outcome.Grp = events$Outcome.Grp, Outcome = events$Outcome), sum)
	x$Cluster <- "Cluster1"
	names(x)[names(x) == "Treatment"] <- "Trt.Grp"
	names(x)[names(x) == "Outcome.Grp"] <- "Outcome.Grp"
	names(x)[names(x) == "Outcome"] <- "Outcome"
	names(x)[names(x) == "Exposure"] <- "Exposure"
	names(x)[names(x) == "events"] <- "Count"
	write.table(x, "SUMMARY.dat")
}

#generate.events()
#summerise.events()
