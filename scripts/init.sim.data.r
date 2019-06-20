create.lambda <- function(C = 10, T = 4, outcomes = "OUTCOMES", r = 0.1, sd = .001)
{
	outcomes <- read.table(outcomes, header = TRUE)

	num.outcomes <- nrow(outcomes)

	#rate <- round(rnorm(num.outcomes *C * T, r, sd), 6)
	#rate <- round(rnorm(num.outcomes * T, r, sd), 6)

# Ensure baseline rates are the same across treatments
	rate <- c()
	for (c in 1:C) {
		rate.t <- round(rnorm(num.outcomes, r, sd), 6)
		for (t in 1:T) {
			rate.t[ rate.t <= 0] = round(r, 6)
			rate <- c(rate, rate.t)
		}
	}

	lambda <- data.frame(Treatment = rep(1:T, each = num.outcomes),
				Outcome.Grp =  rep(outcomes$Outcome.Grp, T),
				Outcome = rep(outcomes$Outcome, T)) #, rate = rate)
	lambda <- do.call("rbind", replicate(C, lambda, simplify = FALSE))
	lambda$Cluster <- rep(1:C, each = num.outcomes * T)
	lambda$rate <- rate

	#rep(1:C, each = num.outcomes * T)
	#rep(rep(1:T, each = num.outcomes), C)
	#rep(outcomes$group, C*T)
	#rep(outcomes$outcome, C*T)

	write.table(lambda, "LAMBDA.base")
}

create.patient.dist <- function(C = 10, p = 0.1)
{
	pat.dist <- data.frame(C = rep(1:C), p = p)

	write.table(pat.dist, "PATIENT.DIST")
}

create.treatment.alloc <- function(C = 10, T = 4, p = NULL)
{
	if (is.null(p)) {
		T.alloc <- data.frame(Cluster = rep(1:C, each = T), Treatment = rep(1:T,C), p = 1/T)
	}
	else {
		if (length(p) == T) {
			p = rep(p, C)
		}
		T.alloc <- data.frame(Cluster = rep(1:C, each = T), Treatment = rep(1:T,C), p = p)
	}
	write.table(T.alloc, "TREATMENT.ALLOC")
}

#T = 4
#C = 10
#p = 0.1

#create.lambda(C, T)
#create.patient.dist(C, p)
#create.treatment.alloc(C, T)
