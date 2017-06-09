#formulas, equations and notation from http://homeweb2.unifr.ch/hungerbu/pub/sonnenuhr/sundial.ps
# and by the paper of C. Blatter (http://dz-srv1.sub.uni-goettingen.de/sub/digbib/loader?did=D241775)

epsilon=23.45*2*pi/360
alpha  =78.5 *2*pi/360
kappa  =0.016722

mu<-function(t,epsilon,alpha,kappa) {
  zaehl= -sin(delta(t,kappa))+tan(epsilon/2)^2*sin(2*(t-alpha)+delta(t,kappa))
  nenn =  cos(delta(t,kappa))+tan(epsilon/2)^2*cos(2*(t-alpha)+delta(t,kappa))
  return( atan(zaehl/nenn) )
}

# approximation by Blatter
psi<-function(t) {
  return(t+delta(t))
}

delta<-function(t,kappa) {
  return( 2*sin(t)*kappa+5/4*sin(2*t)*kappa^2 )
}

png(filename="oet_graph.png", width=1024, height=768, pointsize=12)
par(bg="whitesmoke")
time=seq(-0.6,2*pi+0.4,length=365+(0.6+0.4)/(2*pi)*365)
da<-paste("1.",as.character(seq(1,12,by=2)),".07",sep="")
da<-as.Date(c(da,"1.1.08"),"%d.%m.%y")
#umrechungsfaktor: 24h=2*pi
plot(time,mu(time,epsilon,alpha,kappa)*24*60/(2*pi),type="l",col="red",xlab="Tag",ylab="Time in Minutes",main="Equation of Time: true solar time - mean solar time",cex.main=1.5,lwd=3,xaxt="n",xaxs="i",xlim=range(time))
lines(time,mu(time,epsilon=0,alpha,kappa)*24*60/(2*pi),lwd=2,col="navy",lty="dotdash")
lines(time,mu(time,epsilon,alpha,kappa=0)*24*60/(2*pi),lwd=2,col="purple",lty="dashed")
#grid
abline(h=c(-15,-10,-5,5,10,15),lty="dotted",col="grey")
abline(h=0,lty="solid",col="grey33")
tage=cumsum(c(0,31,28,31,30,31,30,31,31,30,31,30,31))/365-3/365
abline(v=tage*2*pi,lty="dotted",col="grey")
axis(1,at=seq(0,2*pi,length=7)-3*2*pi/365,labels=as.character(da,"1. %b"))
legend(x=5.5,y=-10.9,legend=c("Total Time","Orbital","Oblique"),col=c("red","navy","purple"),lwd=c(3,2,2),lty=c("solid","dotdash","dashed"))
dev.off()