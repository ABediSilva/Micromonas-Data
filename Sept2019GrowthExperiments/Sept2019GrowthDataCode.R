
rm(list=ls())

#libraries
library(readxl)
library(lubridate)
library(ggplot2)
library(glmmTMB)
library(sjPlot)
library(lattice)
library(lme4)
library(effects)
library(stringr)

#set working directory
setwd('')

#read in plate reader data and isolate metadata
db<-read.csv('Sept2019GrowthData.csv')
db$date<-as_datetime(as.character(db$date), tz="HST")
db$short.date<-ymd(db$short.date, tz="HST")

db$RFU<-as.numeric(db$RFU)

##The following code plotes growth curves for each isolate. These plots were used to determine exponential growth phase for each transfer of each isolate.

#High Light Growth Curves 
high<-subset(db, light=="Hi")
days<-unique(high$short.date)

#subtract blanks
for (i in 1:length(days)){
  dates<-subset(high, short.date==days[i])
  blanks<-subset(dates, Host=="blank")
  blanks<-subset(blanks, !(RFU>20))
  mean.b<-mean(blanks$RFU)
  high$bRFU<-(high$RFU-mean.b)
}

#Subsetting by transfer
high<-subset(high, !(bRFU<=0))
hiT1<-subset(high, Transfer=="T1")
hiT2<-subset(high, Transfer=="T2")
hiT3<-subset(high, Transfer=="T3")
hiT4<-subset(high, Transfer=="T4")
hiT5<-subset(high, Transfer=="T5")
hiT6<-subset(high, Transfer=="T6")

hi.in<-rbind(hiT4,hiT5, hiT6)

par(mfrow=c(4,3), mar=c(4,3,1,0))

##Plotting growth curves
Names.hi<-unique(hi.in$unique.newID)
for(i in 1:length(Names.hi)){
  sub.samp<-subset(hi.in, unique.newID==Names.hi[i])
  wk<-unique(sub.samp$Transfer)
  
  for(j in 1:length(wk)){
    sub.week<-subset(sub.samp, Transfer==wk[j])
    plot(bRFU~short.date, sub.week, type='b', main=paste(Names.hi[i], wk[j]), las=2, log='y', cex.main=.95)
  }
}


#Low Light Growth Curves
#subtract blanks
low<-subset(db, light=="Lo")
days<-unique(low$short.date)
for (i in 1:length(days)){
  dates<-subset(low, short.date==days[i])
  blanks<-subset(dates, Host=="blank")
  blanks<-subset(blanks, !(RFU>20))
  mean.b<-mean(blanks$RFU)
  low$bRFU<-(low$RFU-mean.b)
}

low<-subset(low, !(bRFU<=0))
loT1<-subset(low, Transfer=="T1")
loT2<-subset(low, Transfer=="T2")
loT3<-subset(low, Transfer=="T3")
loT4<-subset(low, Transfer=="T4")

lo.in<-rbind(loT1, loT2, loT3, loT4)

par(mfrow=c(4,4), mar=c(4,3,1,0))

Names.lo<-unique(lo.in$unique.newID)
for(i in 1:length(Names.lo)){
  sub.samp<-subset(lo.in, unique.newID==Names.lo[i])
  wk<-unique(sub.samp$Transfer)
  for(j in 1:length(wk)){
    sub.week<-subset(sub.samp, Transfer==wk[j])
    plot(bRFU~short.date, sub.week, type='b', main=paste(Names.lo[i], wk[j]), las=2, log='y')
  }
}

#Reading in exponential growth dates from plot generated above
#dates of exponential growth
HiDates<-read.csv('HiSept2019ExponentialGrowthDates.csv') 

#convert dates from character to date class
vec<-c(2:7)
for (i in vec){
  HiDates[,i]<-mdy(HiDates[,i])
}

#seperating dates based on transfer
hi4.dates<-data.frame("unique.ID"=HiDates$unique.ID,"start"=HiDates$T4.start,"end"=HiDates$T4.end)
hi5.dates<-data.frame("unique.ID"=HiDates$unique.ID,"start"=HiDates$T5.start,"end"=HiDates$T5.end)
hi6.dates<-data.frame("unique.ID"=HiDates$unique.ID,"start"=HiDates$T6.start,"end"=HiDates$T6.end)


LoDates<-read.csv('LoSept2019ExponentialGrowthDates.csv')

vec<-c(2:9)
for (i in vec){
  LoDates[,i]<-mdy(LoDates[,i])
}

lo1.dates<-data.frame("unique.ID"=LoDates$unique.ID,"start"=LoDates$T1.start,"end"=LoDates$T1.end)
lo2.dates<-data.frame("unique.ID"=LoDates$unique.ID,"start"=LoDates$T2.start,"end"=LoDates$T2.end)
lo3.dates<-data.frame("unique.ID"=LoDates$unique.ID,"start"=LoDates$T3.start,"end"=LoDates$T3.end)
lo4.dates<-data.frame("unique.ID"=LoDates$unique.ID,"start"=LoDates$T4.start,"end"=LoDates$T4.end)


#Defining a function to perfome linear regression to determine growth rate for each isolate for each transfer   
merge.reg<-function(x, y){   
  #x is data frame containing information from one particualr transfer, e.g. HiT4, LoT2, etc. 
  #y is data frame containing select dates, eg. hi4.dates, lo1.dates, etc.
  
  par(mfrow=c(4,3), mar=c(4,3,1,0))
  
  reg<-vector() #this represent growth rate, i.e. the results from linear regression
  cell.line<-vector() #name of each isolate
  unique.ID<-vector() #name of each replicate (grown on different plates)
  host<-vector()
  origin.cross<-vector()
  origin.virus<-vector()
  susceptibility<-vector()
  cross.sus<-vector()
  light<-vector() 
  transfer<-vector()  
  plate<-vector() 
  max.rfu<-vector()
  
  Names<-unique(x$newIDs) 
  
  for(i in 1:length(Names)){
    sub.samp<-subset(x, newIDs==Names[i])
    sub.samp<-merge(sub.samp, y)
    
    if (is.na(sub.samp$start[1])) next
    
    sub.date<-subset(sub.samp, sub.samp$start <= sub.samp$short.date & sub.samp$short.date<=sub.samp$end) #only use data from dates of exponential growth
    
    reg[i]<-coef(lm(log(bRFU) ~ date, sub.date))[2]
    cell.line[i]<-as.character(sub.date$newIDs[1])
    unique.ID[i]<-as.character(sub.date$unique.newID[1])
    host[i]<-as.character(sub.date$newHost[1])
    origin.cross[i]<-as.character(sub.date$newCross[1])
    origin.virus[i]<-as.character(sub.date$newVirus[1])
    susceptibility[i]<-as.character(sub.date$Infectivity[1])
    cross.sus[i]<-as.character(sub.date$newCross.Suscpetibility[1])
    light[i]<-as.character(sub.date$light[1])
    transfer[i]<-as.character(sub.date$Transfer[1])
    plate[i]<-as.character(sub.date$Plate[1])
    max.rfu[i]<-max(sub.date$bRFU)
  }
  reg<-reg*(24*3600)  
  reg.df<-data.frame(reg,unique.ID,cell.line,host,origin.virus,origin.cross,susceptibility,cross.sus,light,transfer,plate,max.rfu)  
  return(reg.df)
}


#Using function defined above on growth data
hiT4.reg<-merge.reg(hiT4,hi4.dates)
hiT5.reg<-merge.reg(hiT5,hi5.dates)
hiT6.reg<-merge.reg(hiT6,hi6.dates)
hi.reg<-rbind(hiT4.reg, hiT5.reg, hiT6.reg)

loT1.reg<-merge.reg(loT1,lo1.dates)
loT2.reg<-merge.reg(loT2,lo2.dates)
loT3.reg<-merge.reg(loT3,lo3.dates)
loT4.reg<-merge.reg(loT4,lo4.dates)
lo.reg<-rbind(loT1.reg, loT2.reg, loT3.reg, loT4.reg)

all.reg<-rbind(hi.reg, lo.reg)

#prepping regression data for generalized mixed model
no.blanks<-subset(all.reg, unique.ID!="blank") 
no.blanks<-na.omit(no.blanks)
no.blanks$unique.ID<-no.blanks$unique.ID[,drop=T]

x.13<-c("M1V3 SR", "M1V2 SR" )
x.42<-c("M2V4 SR",  "M2V2 SR",  "M2V3 SR")

#Generalized mixed models
##For M1 cell lines (a.k.a. FL13)
##Main data frame, including high and low light
big.buddy = subset(no.blanks, host=="M1")
#write.csv(big.buddy, file="big.buddy.csv", row.names = F)
##GMM
tmb.mod = glmmTMB(reg ~ susceptibility*light + (1|plate) + (1|cell.line), dispformula=~susceptibility, data=big.buddy)

#running models by host-virus cross
par(mfrow=c(2,3))
for (i in 1:length(x.13)){
  x.sub<-subset(no.blanks, cross.sus==x.13[i])
  x.13s<-subset(no.blanks, cross.sus=="M1S Per")
  x.13df<-rbind(x.sub, x.13s)
  x.mm<-glmmTMB(reg ~ susceptibility*light + (1|plate) + (1|cell.line), dispformula=~susceptibility, data=x.13df)
  mean.CIs<-allEffects(x.mm)[[1]]
  
  plot(allEffects(x.mm), main=paste(x.13[i]))
  plot_model(x.mm, type="re")
}


##For M2 cell lines (a.k.a. FL42)
big.buddy = subset(no.blanks, host=="M2")
##GMM
tmb.mod = glmmTMB(reg ~ susceptibility*light + (1|plate) + (1|cell.line), dispformula=~susceptibility, data=big.buddy)

#running models by host-virus cross
par(mfrow=c(2,3))
for (i in 1:length(x.42)){
  x.sub<-subset(no.blanks, cross.sus==x.42[i])
  x.42s<-subset(no.blanks, cross.sus=="M2S Per")
  x.42df<-rbind(x.sub, x.42s)
  
  x.mm<-glmmTMB(reg ~ susceptibility*light + (1|plate) + (1|cell.line), dispformula=~susceptibility, data=x.42df)
  mean.CIs<-allEffects(x.mm)[[1]]
  
  plot(allEffects(x.mm), main=paste(x.42[i]))
  plot_model(x.mm, type="re") 
}

