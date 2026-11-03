
#######  UNIVARIE  ########################

#lecture des donnees et premiere stats des
data<-read.table("Recensement.txt",header=T)
head(data)
head(data,10)
summary(data)

## modification du type des variables
dat<-read.table("Recensement.txt",header=T)
dat$CATEGORIE=as.factor(dat$CATEGORIE)
dat$NB_ENF=as.factor(dat$NB_ENF)
dat$NB_PERS=as.factor(dat$NB_PERS)
dat$NIV_ETUDES=as.factor(dat$NIV_ETUDES)
dat$REV_FOYER=as.factor(dat$REV_FOYER)
summary(dat)

#tableaux effectifs/fr?quences

## CSP
tabCATeff<-table(data$CATEGORIE)
print(tabCATeff)
tabCATfreq<-round(prop.table(table(data$CATEGORIE)), digit=3)
print(tabCATfreq)
tabCATpour<-round(100*prop.table(table(data$CATEGORIE)), digit=1)
print(tabCATpour)

##Sexe
tabSEXEeff<-table(data$SEXE)
print(tabSEXEeff)
tabSEXEfreq<-round(prop.table(table(data$SEXE)), digit=3)
print(tabSEXEfreq)
tabSEXEpour<-round(100*prop.table(table(data$SEXE)), digit=1)
print(tabSEXEpour)

##Syndicat
tabSYNeff<-table(data$SYNDICAT)
print(tabSYNeff)
tabSYNfreq<-round(prop.table(table(data$SYNDICAT)), digit=3)
print(tabSYNfreq)
tabSYNpour<-round(100*prop.table(table(data$SYNDICAT)), digit=1)
print(tabSYNpour)

##Nbr Enfants
tabNBEeff<-table(data$NB_ENF)
print(tabNBEeff)
cumsum(tabNBEeff)
tabNBEfreq<-round(prop.table(table(data$NB_ENF)), digit=5)
print(tabNBEfreq)
cumsum(tabNBEfreq)
tabNBEpour<-round(100*prop.table(table(data$NB_ENF)), digit=3)
print(tabNBEpour)
cumsum(tabNBEpour)

##Salaire
H<-hist(data$SAL_HOR, breaks=c(0,5,10,15,20,25,30,35,
40,100),
freq=FALSE, right=FALSE)
tabSALeff<-H$count
print(tabSALeff)
cumsum(tabSALeff)
tabSALfreq<-round(prop.table(H$count), digit=3)
print(tabSALfreq)
cumsum(tabSALfreq)
tabSALpour<-round(100*prop.table(H$count), digit=1)
print(tabSALpour)
cumsum(tabSALpour)

##Salaire à partir des déciles
quantile(data$SAL_HOR,probs=seq(0,1,0.1))
decile<-round(quantile(data$SAL_HOR,probs=seq(0,1,0.1)),digit=0)
print(decile)
H=hist(data$SAL_HOR, 
breaks= decile, freq=FALSE, right=FALSE)
tabSALeff<-H$count
print(tabSALeff)
cumsum(tabSALeff)
tabSALfreq<-round(prop.table(H$count), digit=3)
print(tabSALfreq)
cumsum(tabSALfreq)
tabSALpour<-round(100*prop.table(H$count), digit=1)
print(tabSALpour)
cumsum(tabSALpour)

#diagrammes circulaires

##Sexe
pie(table(data$SEXE), main="répartition femme/homme", col=c("blue","green"), clockwise=TRUE, labels=NA)
legend("topleft", legend=c("femme", "homme"), col=c("blue","green"),pch=15)

text_pie = function(vector,labels=c()) 
{
  vector = vector/sum(vector)*2*pi
  temp = c()
  j = 0
  l = 0
  for (i in 1:length(vector)) {
    k = vector[i]/2        
    j =  j+l+k
    l = k
    text(cos(j)/2,sin(j)/2,labels[i])
    text(cos(j)/2+0.11,sin(j)/2,"%")
  }
  vector = temp
}
pour=round(100*prop.table(table(data$SEXE)),digit=1)
pie(table(data$SEXE), main="répartition femme/homme", col=c("blue","green"),  labels=NA)
legend("topleft", legend=c("femme", "homme"), col=c("blue","green"),pch=15)
text_pie(table(data$SEXE),pour)

##Région d'habitation
pour=round(100*prop.table(table(data$REGION)),digit=1)
cumsum(pour)
pie(table(data$REGION), main="Répartition par régions")
text_pie(table(data$REGION),pour)

#diagrammes en barres

##Région d'habitation
barplot(table(data$REGION), main="répartition par régions", ylab="effectif")
y<-sort(table(data$REGION), decreasing=TRUE)
barplot(y, main="répartition par région", ylab="effectif")

##CSP
barplot(prop.table(table(data$CATEGORIE)), main="répartition par 
catégorie professionnelle", ylab="fréquence")

##Niveau d'étude
barplot(prop.table(table(data$NIV_ETUDES)), 
ylab="fréquence", 
xlab="niveau d'étude", 
main="distribution du niveau d'étude")
###Regroupement de classes
data$NIV[data$NIV_ETUDES<39]="A"
data$NIV[data$NIV_ETUDES==39]="B"
data$NIV[data$NIV_ETUDES==40]="C"
data$NIV[data$NIV_ETUDES==42|data$NIV_ETUDES==41]="D"
data$NIV[data$NIV_ETUDES==43]="E"
data$NIV[data$NIV_ETUDES>43]="F"
barplot(table(data$NIV),
ylab="effectif", xlab="niveau d'étude",
main="distribution du niveau d'étude")

#diagramme en bâton
plot(prop.table(table(data$NB_ENF)), ylab="fréquence", 
xlab="nombre d'enfants", 
main="distribution du nombre d'enfants")

#histogrammes du Salaire

##classes par défaut R
hist(data$SAL_HOR, 
main="distribution du salaire horaire", 
xlab="Salaire horaire (en $)",
ylab="densité de fréquence", col="yellow")

##9 classes inégales
hist(data$SAL_HOR, breaks=c(0,5,10,15,20,25,30,35,40,100),
freq=FALSE, right=FALSE,
main="distribution du salaire horaire", 
xlab="Salaire horaire (en $)",
ylab="densité de fréquence", col="yellow")

##9 classes inégales en effectif (histrogramme faux)
hist(data$SAL_HOR, breaks=c(0,5,10,15,20,25,30,35,
40,100),
freq=TRUE, right=FALSE,
main="histogramme FAUX", 
xlab="Salaire horaire (en $)",
ylab="effectif", col="yellow")

##10 classes à partir des déciles
decile<-round(quantile(data$SAL_HOR,probs=seq(0,1,0.1)),digit=0)
hist(data$SAL_HOR, 
breaks= decile, freq=FALSE, right=FALSE, 
main="distribution du salaire horaire", 
xlab="Salaire horaire (en $)",
ylab="densité de fréquence", col="yellow")

##5 classes d'amplitudes égales
hist(data$SAL_HOR, breaks=6,
freq=TRUE, right=FALSE,
main="5 classes d'amplitudes égales", 
xlab="Salaire horaire (en $)",
ylab="effectif", col="yellow")

##50 classes d'amplitudes égales
hist(data$SAL_HOR, breaks=52,
freq=TRUE, right=FALSE,
main="50 classes d'amplitudes égales", 
xlab="Salaire horaire (en $)",
ylab="effectif", col="yellow")

## histogramme de logsal + ajustement gaussien
hist(log(data$SAL_HOR), breaks=c(0.5, 1, 1.75, 2, 2.25, 2.5,2.75, 3, 3.25, 3.5, 3.75,  4.5, 5), freq=FALSE, 
ylab="densité de fréquence", main="histrogramme du log salaire horaire", xlab="log salaire horaire")
curve(dnorm(x,
mean=mean(log(data$SAL_HOR)), 
sd=sd(log(data$SAL_HOR))), add=TRUE)

#fonction de répartition et courbe des fréquences

## FR du salaire
plot(ecdf(data$SAL_HOR),pch=".", main="fonction de répartition empirique
du salaite horaire", xlab="salaire horaire (en $)", 
ylab="fréquences cumulées")

## CFC du salaire
data$CATSAL[data$SAL_HOR<5]="A"
data$CATSAL[data$SAL_HOR<10 & data$SAL_HOR>=5]="B"
data$CATSAL[data$SAL_HOR<15 & data$SAL_HOR>=10]="C"
data$CATSAL[data$SAL_HOR<20 & data$SAL_HOR>=15]="D"
data$CATSAL[data$SAL_HOR<25 & data$SAL_HOR>=20]="E"
data$CATSAL[data$SAL_HOR<30 & data$SAL_HOR>=25]="F"
data$CATSAL[data$SAL_HOR<35 & data$SAL_HOR>=30]="G"
data$CATSAL[data$SAL_HOR<40 & data$SAL_HOR>=35]="H"
data$CATSAL[data$SAL_HOR>=40]="I"
prop.table(table(data$CATSAL))
x<-cumsum(prop.table(table(data$CATSAL)))
plot(c(0,5,10,15,20,25,30,35,
40,100),c(0,x), 
main="courbe des fréquences cumulées du salaire horaire",
xlab="salaire horaire (en $)", 
ylab="fréquences cumulées")
lines(c(0,5,10,15,20,25,30,35,
40,100),c(0,x))

## FR et CFC du salaire
plot(ecdf(data$SAL_HOR),pch=".", main="fonction de répartition et courbe des fréquences cumulées", xlab="salaire horaire (en $)", 
ylab="fréquences cumulées")
lines(c(0,5,10,15,20,25,30,35,
40,100),c(0,x),col="blue")

#Simulations et ajustement

##Simul Gauss
y=rnorm(2000,0,0.6)
boxplot(y, col="yellow", main="données simulées")
hist(y, breaks=c(-2.5, -2.25, -2,-1.75, -1.5, -1.25, -1, -0.75, -0.5, -0.25,
 0, 0.25, 0.5, 0.75,  1, 1.25, 1.5, 1.75, 2, 2.25, 2.5),freq=FALSE, xlab="données simulées", ylab="densité de fréquence", main="ajustement à la famille gaussienne")
 curve(dnorm(x,mean=0, sd=0.6), add=TRUE)
 
##Simul exp
t=rexp(2000,1)
hist(t, freq=FALSE, main="ajustement à la famille exponentielle",
ylab="densité de fréquence", xlab="données simulées")
curve(dexp(x), add=TRUE)
 
#Indicateurs statistiques
summary(data$SAL_HOR)
 
## médiane et quantiles du salaire
median(data$SAL_HOR)
quantile(data$SAL_HOR, 0.5)
quantile(data$SAL_HOR)
quantile(data$SAL_HOR,probs=seq(0,1,0.1))
 
## moyenne du salaire 
mean(data$SAL_HOR)
 
## variance et écart type du salaire
var(data$SAL_HOR)
sqrt(var(data$SAL_HOR))
sd(data$SAL_HOR)
VAR<-(length(data$SAL_HOR)-1)*var(data$SAL_HOR)/length(data$SAL_HOR)
SD<-sqrt(varemp)

##fonctions pour la variance et l'écart-type empirique

Var=function(x)
{
  Var=var(x)*(length(x)-1)/length(x)
  return(Var)
}

Var(data$SAL_HOR)

SD=function(x)
{
  SD=sqrt(var(x)*(length(x)-1)/length(x))
  return(SD)
}

SD(data$SAL_HOR)


# box plots

## box plot du salaire
boxplot(data$SAL_HOR, col="yellow", 
main="boîte à moustache du salaire horaire",
ylab="salaire horaire (en $)")

## salaire selon le sexe
boxplot(data$SAL_HOR~data$SEXE, col="yellow",
main="boîte à moustache du salaire horaire 
selon le sexe")

## Moyenne et médiane du salaire
boxplot(data$SAL_HOR, col="yellow", 
        main="boîte à moustache du salaire horaire",
        ylab="salaire horaire (en $)")
abline(mean(data$SAL_HOR), 0, col="blue", lwd=2)
abline(median(data$SAL_HOR), 0, col="black", lwd=2)
text(0.57,0.994*max(data$SAL_HOR),"moyenne =",col="blue")
text(0.57,max(data$SAL_HOR)-(max(data$SAL_HOR)-min(data$SAL_HOR))/20,"médiane =")
text(0.7,max(data$SAL_HOR), round(mean(data$SAL_HOR),digit=1),col="blue")
text(0.7,max(data$SAL_HOR)-(max(data$SAL_HOR)-min(data$SAL_HOR))/20, 
     round(median(data$SAL_HOR),digit=1))

legend("topleft", legend=c("moyenne = 17.9$", "médiane = 15$"),
text.col=c("blue", "black"))

## Moyenne et médiane de l'âge
boxplot(data$AGE, col="yellow", 
        main="boîte à moustache de l'âge",
        ylab="salaire horaire (en $)")
abline(mean(data$AGE), 0, col="blue", lwd=2)
abline(median(data$AGE), 0, col="black", lwd=2)
text(0.57,max(data$AGE),"moyenne =",col="blue")
text(0.57,max(data$AGE)-(max(data$AGE)-min(data$AGE))/20,"médiane =")
text(0.7,max(data$AGE), round(mean(data$AGE),digit=1),col="blue")
text(0.7,max(data$AGE)-(max(data$AGE)-min(data$AGE))/20, 
     round(median(data$AGE),digit=1))
boxplot(data$AGE, col="yellow", 
main="boîte à moustache de l'âge",
ylab="âge")
abline(mean(data$AGE), 0, col="blue", lwd=2)
abline(median(data$AGE), 0, col="black", lwd=2)
legend("topleft", legend=c("moyenne = 41.8 ans", "médiane = 42 ans"),
text.col=c("blue", "black"))

#Simulations box plots Gauss
x=rnorm(2000,0,0.3)
y=rnorm(2000,0,0.6)
boxplot(x,y, col="yellow", main="données simulées")

#Annexe

## CFC Revenu par foyer
x<-round(cumsum(prop.table(table(data$REV_FOYER))), 
digit=2)
plot(c(0,5000,7500,10000,12500,15000, 20000, 
25000, 30000, 35000, 40000, 
50000, 60000, 75000, 100000, 150000, 300000),c(0,x), 
main="courbe des fréquences cumulées 
du revenu par foyer",
xlab="revenu par foyer", 
ylab="fréquences cumulées")
lines(c(0,5000,7500,10000,12500,15000, 20000, 
25000, 30000, 35000, 40000, 
50000, 60000, 75000, 100000, 150000, 300000),c(0,x))


##Courbe de concentration du salaire
p=cumsum(prop.table(table(data$CATSAL)))
x=tapply(data$SAL_HOR, data$CATSAL, sum)
y=prop.table(x)
q=cumsum(y)
print(p)
print(q)
plot(c(0,p),c(0,q), 
main="courbe de concentration du salaire horaire",
xlab="part de la population", 
ylab="part de la masse salariale")
lines(c(0,p),c(0,q))
lines(c(0,1), c(0,1), col="red")



##################  BIVARIE #########################


## tableaux de contingence
# Sexe et Région
table(data$SEXE,data$REGION)
addmargins(table(data$SEXE,data$REGION))
prop.table(table(data$SEXE,data$REGION))
addmargins(prop.table(table(data$SEXE,data$REGION)))
round(addmargins(prop.table(table(data$SEXE,data$REGION))),2)
# Sexe et Catégorie
table(data$SEXE,data$CATEGORIE)
addmargins(table(data$SEXE,data$CATEGORIE))
prop.table(table(data$SEXE,data$CATEGORIE))
addmargins(prop.table(table(data$SEXE,data$CATEGORIE)))
round(addmargins(prop.table(table(data$SEXE,data$CATEGORIE))),2)
# Syndicat et région
table(data$SYNDICAT,data$REGION)
addmargins(table(data$SYNDICAT,data$REGION))
prop.table(table(data$SYNDICAT,data$REGION))
addmargins(prop.table(table(data$SYNDICAT,data$REGION)))
round(addmargins(prop.table(table(data$SYNDICAT,data$REGION))),2)
# Sexe et Salaire
data$CATSAL2[data$SAL_HOR<=10]="A"
data$CATSAL2[data$SAL_HOR<=15 & data$SAL_HOR>10]="B"
data$CATSAL2[data$SAL_HOR<=20 & data$SAL_HOR>15]="C"
data$CATSAL2[data$SAL_HOR<=30 & data$SAL_HOR>20]="D"
data$CATSAL2[data$SAL_HOR<=40 & data$SAL_HOR>30]="E"
data$CATSAL2[data$SAL_HOR>40]="F"
table(data$SEXE,data$CATSAL2)
addmargins(table(data$SEXE,data$CATSAL2))
prop.table(table(data$SEXE,data$CATSAL2))
addmargins(prop.table(table(data$SEXE,data$CATSAL2)))
round(addmargins(prop.table(table(data$SEXE,data$CATSAL2))),2)

## Distributions conditionnelles
# Region selon F/M
prop.table(table(data$SEXE,data$REGION),1)
round(addmargins(prop.table(table(data$SEXE,data$REGION), 1), 2), 2)
# F/M selon la région
prop.table(table(data$SEXE,data$REGION),2)
round(addmargins(prop.table(table(data$SEXE,data$REGION), 2), 1), 2)
#Categorie selon F/M
prop.table(table(data$SEXE,data$CATEGORIE),1)
round(addmargins(prop.table(table(data$SEXE,data$CATEGORIE), 1), 2), 2)
#F/M selon Categorie
prop.table(table(data$SEXE,data$CATEGORIE),2)
round(addmargins(prop.table(table(data$SEXE,data$CATEGORIE), 2), 1), 2)
# Syndicat selon Region
prop.table(table(data$SYNDICAT,data$REGION),2)
round(addmargins(prop.table(table(data$SYNDICAT,data$REGION), 2), 1), 2)
# Syndicat selon Categorie
prop.table(table(data$SYNDICAT,data$CATEGORIE),2)
round(addmargins(prop.table(table(data$SYNDICAT,data$CATEGORIE), 2), 1), 2)
#Salaire selon F/M
prop.table(table(data$SEXE,data$CATSAL2),1)
round(addmargins(prop.table(table(data$SEXE,data$CATSAL2), 1), 2), 2)



## Indicateurs conditionnels

# Salaire selon F/M
tapply(data$SAL_HOR, data$SEXE, mean)
tapply(data$SAL_HOR, data$SEXE, median)
tapply(data$SAL_HOR, data$SEXE, Var)
tapply(data$SAL_HOR, data$SEXE, SD)
# Salaire selon region
tapply(data$SAL_HOR, data$REGION, mean)
tapply(data$SAL_HOR, data$REGION, median)
tapply(data$SAL_HOR, data$REGION, Var)
tapply(data$SAL_HOR, data$REGION, SD)
# Salaire selon Categorie
tapply(data$SAL_HOR, data$CATEGORIE, mean)
tapply(data$SAL_HOR, data$CATEGORIE, median)
tapply(data$SAL_HOR, data$CATEGORIE, Var)
tapply(data$SAL_HOR, data$CATEGORIE, SD)

## Représentation des distributions conditionnelles (quali/quali)
# Region selon F/M
barplot(prop.table(table(data$REGION,data$SEXE),2))
# F/M selon la region
barplot(prop.table(table(data$SEXE,data$REGION),2))
#Categorie selon F/M
barplot(prop.table(table(data$CATEGORIE,data$SEXE),2))
#F/M selon Categorie
barplot(prop.table(table(data$SEXE,data$CATEGORIE),2))
# Syndicat selon F/M
barplot(prop.table(table(data$SYNDICAT,data$SEXE),2))
# F/M selon Syndicat
barplot(prop.table(table(data$SEXE,data$SYNDICAT),2))

## boxplots conditionnels
# Salaire selon F/M
boxplot(data$SAL_HOR~data$SEXE, main="Bôites à moustache du salaire horaire selon le sexe", 
        col="yellow")
# Salaire selon region
boxplot(data$SAL_HOR~data$REGION, main="Bôites à moustache du salaire horaire selon la région", 
        col="yellow")
# Salaire selon Categorie
boxplot(data$SAL_HOR~data$CATEGORIE, main="Bôites à moustache du salaire horaire selon la 
        catégorie", col="yellow")
# Salaire selon niveau etudes
boxplot(data$SAL_HOR~data$NIV, main="Bôites à moustache du salaire horaire selon 
        le niveau d'études", col="yellow")
# Salaire selon Syndicat
boxplot(data$SAL_HOR~data$SYNDICAT, main="Bôites à moustache du salaire horaire selon 
l'appartenance à un syndicat", col="yellow")

## Vinter, Vintra, Rapport de correlation, Fisher et p-valeur

Var=function(x)
{
  Var=var(x)*(length(x)-1)/length(x)
  return(Var)
}

Vinter=function(X,F)
{
  F<-as.factor(F)
  MeanCond=tapply(X, F, mean)
  VarCond=tapply(X, F, Var)
  Prop=prop.table(table(F))
  VINTER=sum(MeanCond^2*Prop)-mean(X)^2
  return(VINTER)
}

Vintra=function(X,F)
{
  F<-as.factor(F)
  MeanCond=tapply(X, F, mean)
  VarCond=tapply(X, F, Var)
  Prop=prop.table(table(F))
  VINTRA=sum(VarCond*Prop)
  return(VINTRA)
}

RapCor=function(X,F)
{
  RAPCOR<-Vinter(X,F)/(Var(X))
  return(RAPCOR)
}

Fisher=function(X, F)
{
  F<-as.factor(F)
  A<-anova(lm(X~F))
  FISHER<-A$`F value`[1]
  print(FISHER)
  PVAL_FISHER<-A$`Pr(>F)`[1]
  print(PVAL_FISHER)
}

Vinter(data$SAL_HOR, data$SEXE)
Vintra(data$SAL_HOR, data$SEXE)
RapCor(data$SAL_HOR, data$SEXE)
Fisher(data$SAL_HOR, data$SEXE)

Vinter(data$SAL_HOR, data$SYNDICAT)
Vintra(data$SAL_HOR, data$SYNDICAT)
RapCor(data$SAL_HOR, data$SYNDICAT)
Fisher(data$SAL_HOR, data$SYNDICAT)


Vinter(data$SAL_HOR, data$CATEGORIE)
Vintra(data$SAL_HOR, data$CATEGORIE)
RapCor(data$SAL_HOR, data$CATEGORIE)
Fisher(data$SAL_HOR, data$CATEGORIE)

Vinter(data$SAL_HOR, data$NIV)
Vintra(data$SAL_HOR, data$NIV)
RapCor(data$SAL_HOR, data$NIV)
Fisher(data$SAL_HOR, data$NIV)



## Age et autre variables quali
# Age selon F/M
boxplot(data$AGE~data$SEXE, main="Bôites à moustache de l'âge selon le sexe", 
        col="yellow")
Vinter(data$AGE, data$SEXE)
Vintra(data$AGE, data$SEXE)
RapCor(data$AGE, data$SEXE)
Fisher(data$AGE, data$SEXE)
# Age selon region
boxplot(data$AGE~data$REGION, main="Bôites à moustache de l'âge selon la région", 
        col="yellow")
Vinter(data$AGE, data$REGION)
Vintra(data$AGE, data$REGION)
RapCor(data$AGE, data$REGION)
Fisher(data$AGE, data$REGION)
# Age selon Categorie
boxplot(data$AGE~data$CATEGORIE, main="Bôites à moustache de l'âge selon la catégorie", 
        col="yellow")
Vinter(data$AGE, data$CATEGORIE)
Vintra(data$AGE, data$CATEGORIE)
RapCor(data$AGE, data$CATEGORIE)
Fisher(data$AGE, data$CATEGORIE)
# Age selon niveau etudes
boxplot(data$AGE~data$NIV, main="Bôites à moustache de l'âge selon le niveau d'études", 
        col="yellow")
Vinter(data$AGE, data$NIV)
Vintra(data$AGE, data$NIV)
RapCor(data$AGE, data$NIV)
Fisher(data$AGE, data$NIV)
# Age selon Syndicat
boxplot(data$AGE~data$SYNDICAT, main="Bôites à moustache de l'âge selon l'appartenance à un 
        syndicat", col="yellow")
Vinter(data$AGE, data$SYNDICAT)
Vintra(data$AGE, data$SYNDICAT)
RapCor(data$AGE, data$SYNDICAT)
Fisher(data$AGE, data$SYNDICAT)


## Indicateur du Chi2 et test du Chi2
# Region selon F/M
barplot(prop.table(table(data$REGION,data$SEXE),2), col=c("blue", "green", "yellow", "orange"),
        ylab="fréquences",
        main="Répartiton par région selon le sexe", ylim=c(0,1.15))
legend(legend=c("NE", "NW", "S", "W"), col=c("blue","green", "yellow", "orange") ,pch=15, x=0.85, 
       y=1.15, horiz=T)
chisq.test(table(data$REGION,data$SEXE))
addmargins(table(data$REGION,data$SEXE))
round(addmargins(chisq.test(table(data$REGION,data$SEXE))$expected), 2)
# F/M selon categorie
barplot(prop.table(table(data$SEXE,data$CATEGORIE),2),
        col=c("blue", "green"),
        ylab="fréquences",
        main="répartiton femmes/hommes par catégorie", ylim=c(0,1.15))
legend(legend=c("femme", "homme"), col=c("blue","green") ,pch=15, x=4, 
       y=1.15, horiz=T)
chisq.test(table(data$SEXE,data$CATEGORIE))
addmargins(table(data$SEXE,data$CATEGORIE))
round(addmargins(chisq.test(table(data$SEXE,data$CATEGORIE))$expected), 2)
# Region selon categorie
barplot(prop.table(table(data$REGION,data$CATEGORIE),2), col=c("blue", "green", "yellow", "orange"),
        ylab="fréquences",
        main="Répartiton par région selon la catégorie", ylim=c(0,1.15))
legend(legend=c("NE", "NW", "S", "W"), col=c("blue","green", "yellow", "orange") ,pch=15, x=3, 
       y=1.15, horiz=T)
chisq.test(table(data$REGION,data$CATEGORIE))
addmargins(table(data$REGION,data$CATEGORIE))
round(addmargins(chisq.test(table(data$REGION,data$CATEGORIE))$expected),2)
#  F/M selon Syndicat
barplot(prop.table(table(data$SEXE,data$SYNDICAT),2),
        col=c("blue", "green"),
        ylab="fréquences",
        main="répartiton femmes/hommes selon l'apparteance à un syndicat", ylim=c(0,1.15))
legend(legend=c("femme", "homme"), col=c("blue","green") ,pch=15, x=1, 
       y=1.15, horiz=T)
chisq.test(table(data$SEXE,data$SYNDICAT))
addmargins(table(data$SYNDICAT,data$SEXE))
round(addmargins(chisq.test(table(data$SYNDICAT,data$SEXE))$expected), 2)
# Syndicat selon Region
barplot(prop.table(table(data$SYNDICAT,data$REGION),2),
        col=c("blue", "green"),
        ylab="fréquences",
        main="Syndiqués/Non syndiqués selon la région", ylim=c(0,1.15))
legend(legend=c("non syndiqués", "syndiqués"), col=c("blue","green") ,pch=15, x=1.5, 
       y=1.15, horiz=T)
chisq.test(table(data$SYNDICAT,data$REGION))
addmargins(table(data$SYNDICAT,data$REGION))
round(addmargins(chisq.test(table(data$SYNDICAT,data$REGION))$expected), 2)
# Syndicat selon catégorie
barplot(prop.table(table(data$SYNDICAT,data$CATEGORIE),2), 
        col=c("blue", "green"),
        ylab="fréquences",
        main="Syndiqués/Non syndiqués selon la catégorie", ylim=c(0,1.15))
legend(legend=c("non syndiqués", "syndiqués"), col=c("blue","green") ,pch=15, x=3, 
       y=1.15, horiz=T)
chisq.test(table(data$SYNDICAT,data$CATEGORIE))
table(data$SYNDICAT,data$CATEGORIE)
round(addmargins(chisq.test(table(data$SYNDICAT,data$CATEGORIE))$expected), 2)


## Exemple du salaire F/M

# Catégorie A (hauts salaires medians) et B (bas salaires medians)
data$CATSAL[data$CATEGORIE=="1"|data$CATEGORIE=="2"|
              data$CATEGORIE=="7"|data$CATEGORIE=="8"|
              data$CATEGORIE=="9"]="A"
data$CATSAL[data$CATEGORIE=="3"|data$CATEGORIE=="4"|
              data$CATEGORIE=="5"|data$CATEGORIE=="6"|
              data$CATEGORIE=="10"]="B"
table(data$CATSAL)

# Boxplots  et indicateurs salaire haraire sachant Cat A, B
boxplot(data$SAL_HOR~data$CATSAL, col="yellow",
        main="salaire horaire selon la catégorie", 
        ylab="salaire horaire (en $)")
tapply(data$SAL_HOR, data$CATSAL, mean)
tapply(data$SAL_HOR, data$CATSAL, median)
tapply(data$SAL_HOR, data$CATSAL, Var)




# Salaire F/M Cat A
boxplot(data$SAL_HOR[data$CATSAL=="A"]~data$SEXE[data$CATSAL=="A"],
        col="yellow",
        ylab="salaire horaire (en $)",
        main="salaire horaire femmes/hommes pour Cat A")

tapply(data$SAL_HOR[data$CATSAL=="A"],data$SEXE[data$CATSAL=="A"], mean)
tapply(data$SAL_HOR[data$CATSAL=="A"],data$SEXE[data$CATSAL=="A"], median)
tapply(data$SAL_HOR[data$CATSAL=="A"],data$SEXE[data$CATSAL=="A"], Var)

Vinter(data$SAL_HOR[data$CATSAL=="A"], data$SEXE[data$CATSAL=="A"])
Vintra(data$SAL_HOR[data$CATSAL=="A"], data$SEXE[data$CATSAL=="A"])
RapCor(data$SAL_HOR[data$CATSAL=="A"], data$SEXE[data$CATSAL=="A"])
Fisher(data$SAL_HOR[data$CATSAL=="A"], data$SEXE[data$CATSAL=="A"])
t.test(data$SAL_HOR[data$CATSAL=="A"]~data$SEXE[data$CATSAL=="A"])

# Salaire F/M Cat B
boxplot(data$SAL_HOR[data$CATSAL=="B"]~data$SEXE[data$CATSAL=="B"],
        col="yellow",
        ylab="salaire horaire (en $)",
        main="salaire horaire femmes/hommes pour Cat B")
tapply(data$SAL_HOR[data$CATSAL=="B"],data$SEXE[data$CATSAL=="B"], mean)
tapply(data$SAL_HOR[data$CATSAL=="B"],data$SEXE[data$CATSAL=="B"], median)
tapply(data$SAL_HOR[data$CATSAL=="B"],data$SEXE[data$CATSAL=="B"], Var)
modele<-lm(data$SAL_HOR[data$CATSAL=="B"]~data$SEXE[data$CATSAL=="B"]) 

Vinter(data$SAL_HOR[data$CATSAL=="B"], data$SEXE[data$CATSAL=="B"])
Vintra(data$SAL_HOR[data$CATSAL=="B"], data$SEXE[data$CATSAL=="B"])
RapCor(data$SAL_HOR[data$CATSAL=="B"], data$SEXE[data$CATSAL=="B"])
Fisher(data$SAL_HOR[data$CATSAL=="B"], data$SEXE[data$CATSAL=="B"])
t.test(data$SAL_HOR[data$CATSAL=="B"]~data$SEXE[data$CATSAL=="B"])

# Repartition F/M par categorie A/B
barplot(prop.table(table(data$SEXE,data$CATSAL),2),col=c("blue", "green"),
        ylab="fréquences",
        main="répartiton femmes/hommes par catégorie", ylim=c(0,1.15))
legend(legend=c("femme", "homme"), col=c("blue","green") ,pch=15, x=1, 
       y=1.15, horiz=T)

addmargins(table(data$SEXE,data$CATSAL))
addmargins(round(100*prop.table(table(data$SEXE, data$CATSAL),2), digit=2),1)
chisq.test(table(data$SEXE,data$CATSAL),correct = F)
addmargins(round(chisq.test(table(data$SEXE,data$CATSAL),correct = F)$expected))








