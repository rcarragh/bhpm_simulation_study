nSims <- 1000
#nSims <- 20
#nSims <- 5
#nSims <- 10
#nSims <- 7


# Outcomes raised in all clusters
o <- c("Outcome3", "Outcome4", "Outcome5")
outcome <- rep(o, 10)
cluster = c("Cluster1", "Cluster2", "Cluster3", "Cluster4", "Cluster5", "Cluster6", "Cluster7", "Cluster8", "Cluster9", "Cluster10")
cluster = rep(cluster, each = 3)
treatment = rep(2, 30)

# Add in those raised in selective clusters
outcome = c(outcome, c("Outcome7", "Outcome8"))
cluster = c(cluster, c("Cluster9", "Cluster9"))
treatment = c(treatment, c(3,3))
raised <- data.frame(
	Outcome = outcome,
	Cluster = cluster,
	Trt.Grp = treatment,
	stringsAsFactors = FALSE)

# Totals
total.outcomes = nSims * 9 * 4 # 9 outcomes x 4 treatments
total.outcomes.clustered = nSims * 9 * 4 * 10 # 9 outcomes x 10 clusters x 4 treatments
total.comp.with.baseline.cluster <- nSims * 10 * 9 * 3
total.raised.clustered = nSims * nrow(raised)

z.d <- duplicated(raised[, c("Outcome", "Trt.Grp")])
raised.no.cluster <- raised[!z.d,]
total.raised.no.cluster = nSims * nrow(raised.no.cluster)

wd <- getwd()

pBB.c.h3.l0 <- "ptheta_by_cluster_BB_hier3_lev0.dat"
p1a.c.h3.l0 <- "ptheta_by_cluster_1a_hier3_lev0.dat"
pBB.c.h3.l1 <- "ptheta_by_cluster_BB_hier3_lev1.dat"
p1a.c.h3.l1 <- "ptheta_by_cluster_1a_hier3_lev1.dat"

ptheta.file <- data.frame(file = c(
"ptheta_by_cluster_1a_hier3_lev0.dat",
"ptheta_by_cluster_1a_hier3_lev1.dat",
"ptheta_by_cluster_BB_hier3_lev0.dat",
"ptheta_by_cluster_BB_hier3_lev1.dat"),
method = c("1ah3l0C", "1ah3l1C", "BBh3l0C", "BBh3l1C"),
cluster = c(T,T,T,T),
sig.level = c(0.95, 0.95, 0.9, 0.9),
total.raised = c(total.raised.clustered,total.raised.clustered,total.raised.clustered,total.raised.clustered),
stringsAsFactors = FALSE)

results <- data.frame(method = ptheta.file$method, correct = rep(0,nrow(ptheta.file)), incorrect = rep(0, nrow(ptheta.file)), missed = rep(0, nrow(ptheta.file)),
	total.raised = c(total.raised.clustered,total.raised.clustered,total.raised.clustered,total.raised.clustered),
	total.comp.with.baseline = c(total.comp.with.baseline.cluster, total.comp.with.baseline.cluster, total.comp.with.baseline.cluster, total.comp.with.baseline.cluster),
	stringsAsFactors = FALSE)

for (i in 1:nSims) {

	dir = sprintf("%s/%d", wd, i)

	setwd(dir)

	for (f in 1:nrow(ptheta.file)) {
		file <- ptheta.file[f,]$file
		method <- ptheta.file[f,]$method
		use.cluster <- ptheta.file[f,]$cluster
		sig.level <- ptheta.file[f,]$sig.level
		p <- read.table(file, header = TRUE)

		p.sig <- p [p$ptheta > sig.level,]

		correct <- 0
		missed <- 0

		for (j in 1:nrow(raised)) {
			r = raised[j,]
			matches <- p.sig[(as.character(p.sig$Outcome) == as.character(r$Outcome)) & (p.sig$Trt.Grp == r$Trt.Grp) & (as.character(p.sig$Cluster) == as.character(r$Cluster)), ]

			if (nrow(matches) == 0) {
				# We've definitely missed this outcome
				missed = missed + 1
			}
			else {
				correct = correct + 1
			}
		}
		results[results$method == method,]$correct = results[ results$method == method,]$correct + correct
		results[results$method == method,]$missed = results[ results$method == method,]$missed + missed
		results[results$method == method,]$incorrect = results[ results$method == method,]$incorrect + nrow(p.sig) - correct

	}

	setwd(wd)
}

print(results)

sink("sim2_results.dat")
print(results)
sink()

