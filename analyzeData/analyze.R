library(growthcurver)
library(ggplot2)
library(glogis)
library(dplyr)
library(dtplyr)
library(plyr)
library(lme4)

no.of.days<-function(ver){
  # Calculate Days
  
  startdate <- as.Date(as.character(ver[1]))
  numDays <- difftime(as.Date(as.character(ver)),startdate ,units="days")
  
  return(as.numeric(numDays))
}



st=read.csv("C:/Users/rifat/Desktop/R_milan/githubRepo/ExperimentalData/DBpedia/DBpedia10ClassEntityCount.csv",head=T)

st<-st[st$class!="dbo-place",]



fnSlope <- function(xseq, yseq) { c(0, diff(xseq)/diff(yseq)) }

entity= ddply(st,.(class), here(transform), days=fn(Release))

entity= ddply(entity,.(class), here(transform), Slope=fnSlope(days,count))

entity_person<-entity[entity$class=="dbo-work",]

ggplot(data=entity_person, aes(x=days, y=count, group=class,color=class)) +
  geom_line() +
  geom_point()

p <- ggplot(entity_person, aes(x = days, y = count)) + geom_line() + geom_point()
p

p <- p + labs(x = "Days",
              y = "Count")
p


my.lm <- lm(count ~ days, data = entity_person)
summary(my.lm)

# a linear model with data for the part after 16 km
my.lm2 <- lm(count ~ days, data = entity_person[entity_person$count > 4000, ])
summary(my.lm2)

# Extract te coefficients from the overall model
my.coef <- coef(my.lm)

# add the regression line to the graph
# setting the aesthetics to a constant - this provides a name that we can reference later when we add additional layers
p <- p + geom_abline(intercept = my.coef[1], 
                     slope = my.coef[2])
p

#for fun: Polynom, third degree: ?poly
# how to use a polynom in a linear model
my.lm3 <- lm(count ~ poly(days, 3), data = entity_person)

p + geom_smooth(method = "lm",
                formula = y ~ poly(x, degree = 3), 
                se = FALSE, colour = "orange")


# Segmentation

library(segmented)
my.seg <- segmented(my.lm, 
                    seg.Z = ~ days, 
                    psi = NA,
                    control = seg.control(K=1))

my.seg <- segmented(my.lm, 
                    seg.Z = ~ days, 
                    psi = list(days = c(1010)))

# model.lm = segmented(lm(y~x,data = data),seg.Z = ~x, psi = NA, control = seg.control(K=1)
summary(my.seg)

my.seg$psi
slope(my.seg)

# get the fitted data
my.fitted <- fitted(my.seg)
my.model <- data.frame(days = entity_person$days, count = my.fitted)

# plot the fitted model
ggplot(my.model, aes(x = days, y = count)) + geom_line()

# add the fitted data to the exisiting plot
p + geom_line(data = my.model, aes(x = days, y = count), colour = "tomato")

# add vertical lines to indicate the break locations
# second row of the psi-matrix
my.lines <- my.seg$psi[, 2]

p <- p + geom_vline(xintercept = my.lines, linetype = "dashed")
p

my.slopes <- coef(my.seg)
slope(my.seg)
# help(slope)
my.seg


# get the slopes manually - excercise!!
my.slopes <- coef(my.seg)

# first line: 
#y = b0 + b1*x
#y = intercept1 + slope1 * x

# second line:
#y = c0 + c1*x
#y = intercept2 + slope2 * x

# third line
#y = d0 + d1 *x
#y = intercept3 + slope3 * x

# At the breakpoint (break1), the segments b and c intersect

#b0 + b1*x = c0 + c1*x

b0 <- coef(my.seg)[[1]]
b1 <- coef(my.seg)[[2]]

# Important:
# the coefficients are the differences in slope in comparison to the previous slope
c1 <- coef(my.seg)[[2]] + coef(my.seg)[[3]]
break1 <- my.seg$psi[[3]]

#Solve for c0 (intercept of second segment):
c0 <- b0 + b1 * break1 - c1 * break1


# At the breakpoint (break2), the two lines are the same again:
# the coefficients are the differences in slope in comparison to the previous slope
d1 <- coef(my.seg)[[4]] + c1
break2 <- my.seg$psi[[4]]

#Solve for d0 (intercept of third segment):
d0 <- c0 + c1 * break2 - d1 * break2

# adding lines to the graph

# line before first breakpoint
p <- p + geom_abline(intercept = b0, slope = b1, 
                     aes(colour = "first part"), show_guide = TRUE)
p

# line after first breakpoint
p <- p + geom_abline(intercept = c0, slope = c1, 
                     aes(colour = "second part"), show_guide = TRUE)
p

#====================== Argon Data ============================== 

aragonData=read.csv("./sampleData/observation.csv",head=T)

entity = ddply(aragonData,.(className), here(transform), days=no.of.days(Release))

entitySummary = ddply(entity, .(className), here(summarize),  mean=mean(count), sd=sd(count))

entityNorm = entity

entityNorm$countNorm=(entityNorm$count-entitySummary$mean)/entitySummary$sd

p <- ggplot(entityNorm, aes(x = days, y = countNorm)) + geom_line() + geom_point()
p <- p + labs(x = "Days", y = "Count Normalized")
p

my.lm <- lm(countNorm ~ days, data = entityNorm)
summary(my.lm)

# Extract te coefficients from the overall model
my.coef <- coef(my.lm)

# add the regression line to the graph
# setting the aesthetics to a constant - this provides a name that we can reference later when we add additional layers
p <- p + geom_abline(intercept = my.coef[1], 
                     slope = my.coef[2])
p

#for fun: Polynom, third degree: ?poly
# how to use a polynom in a linear model

p + geom_smooth(method = "lm",
                formula = y ~ poly(x, degree = 3), 
                se = FALSE, colour = "orange")


# Segmentation

library(segmented)
my.seg <- segmented(my.lm, 
                    seg.Z = ~ days, 
                    psi = NA,
                    control = seg.control(K=1))


 # my.seg <- segmented(my.lm, 
 #                      seg.Z = ~ days, 
 #                      psi = list(days = c(1010)))

# model.lm = segmented(lm(y~x,data = data),seg.Z = ~x, psi = NA, control = seg.control(K=1)
summary(my.seg)

my.seg$psi
slope(my.seg)

# get the fitted data
my.fitted <- fitted(my.seg)
my.model <- data.frame(days = entity$days, count = my.fitted)

# plot the fitted model
ggplot(my.model, aes(x = days, y = count)) + geom_line()

# add vertical lines to indicate the break locations
# second row of the psi-matrix
my.lines <- my.seg$psi[, 2]

p <- p + geom_vline(xintercept = my.lines, linetype = "dashed")
p

# add the fitted data to the exisiting plot
p + geom_line(data = my.model, aes(x = days, y = count), colour = "tomato")



my.slopes <- coef(my.seg)
slope(my.seg)
# help(slope)
my.seg
