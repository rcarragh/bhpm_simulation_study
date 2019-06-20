raised <- data.frame(
Outcome = c("Outcome3", "Outcome4", "Outcome5", "Outcome7", "Outcome8"),
Cluster = c(0, 0, 0, 9, 9),
Treatment = c(2,2,2,3,3),
raised = c(1.1, 1.1, 1.01, 1.1, 1.01),
stringsAsFactors = FALSE)

l = read.table("LAMBDA.base", h = T)

for (i in 1:nrow(raised)) {
	r = raised[i,]

	if (r$Cluster == 0) {
		l[ l$Outcome == r$Outcome & l$Treatment == r$Treatment, ]$rate =
			l[ l$Outcome == r$Outcome & l$Treatment == r$Treatment, ]$rate * r$raised
	}
	else {
		l[ l$Outcome == r$Outcome & l$Treatment == r$Treatment &
			l$Cluster == r$Cluster, ]$rate =
			l[ l$Outcome == r$Outcome & l$Treatment == r$Treatment &
			 l$Cluster == r$Cluster, ]$rate * r$raised
	}

}
write.table(l, "LAMBDA")
