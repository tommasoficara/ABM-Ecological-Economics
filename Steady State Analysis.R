setwd("~/Documents/Reseach Project")

rm(list=ls())


carrying_capacity = 2000

count_fisheries = 1000

K=seq(from=0, to = carrying_capacity, by=1)



ah=function(data)
{H= 24 * (10 *(83 - (0.008 * 83^2))  * ((data)/ carrying_capacity)) * (83)/(24*83)
return(H)
}

plot(K, ah(K), ylim=c(0,200), type="l", main="Steady States Analysis D-Equilibrium", ylab="AH(K), G(K)")
a=0.21

G=function(data)
{
  Gi= a * (data) * (1-((data)/carrying_capacity))
  return(Gi)
}


lines(K, G(K))

intersect(G(K), ah(K))
abline(v=685, lty="dashed")
abline(v=20, lty="dashed", col="red")

legend("topright", cex=0.6, legend=c("Ks = 685"), lty=c("dashed"), col=c("black"))




ah(1)
a=0.21
delta=function(data1)
{
 d= 0.21 * (data1) * (1-((data1)/carrying_capacity))-24* ((10 *(83 - 0.008 * 83^2)  * ((data1)/ carrying_capacity)) * (83)/(24*83))
  return(d)
}

K=seq(from=0, to = carrying_capacity, by=1)

delta(K)
plot(K, delta(K), xlim=c(0,1000), ylim=c(-50, 50), type="l", main = "Change in Resource Stock - D_Equilibrium")
abline(v=uniroot(delta, lower = 50, upper= 1000)[1], lty="dashed")
abline(h=0)
abline(v=20, lty="dashed", col="red")
legend("topright", cex=0.6, legend=c("Ks = 685", "Kmin=20"), lty=c("dashed"), col=c("black", "red"))


delta=function(x, y)
{
  d= (0.21 * (x) * (1-((x)/carrying_capacity)))-24* ((10 *(y - 0.008 * y^2)  * ((x)/ carrying_capacity)) * (y)/(24*y))
  return(d)
}


delta(K, x)


plot(K, delta(K, x))
legend("topright", cex=0.6, legend=c("Ks = 685"), lty=c("dashed"), col=c("black"))

############

AHCE=function(data)
{H= 24 * (10 *(30 - (0.008 * 30^2))  * ((data)/ carrying_capacity)) * (30)/(24*30)
return(H)
}


plot(K, AHCE(K), ylim=c(0,200), type="l", main="Steady State Analysis C-E-Equilibrium", ylab="AH(K), G(K)")
lines(K, G(K))

abline(v=902, lty="dashed")
abline(v=20, lty="dashed", col="red")
legend("topright", cex=0.6, legend=c("Ks = 902", "Kmin=20"), lty=c("dashed"), col=c("black", "red"))


lines(K, ah(K))



