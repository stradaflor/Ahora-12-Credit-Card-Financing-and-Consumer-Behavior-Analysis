

###ANALISIS DE COMPONENTES PRINCIPALES####

library(readxl)

getwd()
AHORA12<-read_excel("/Users/florenciastrada/Desktop/MAESTRIA DE DATOS/4.MULTIVARIADOS/COMPONENTES PRINCIPALES/AHORA12v3.xlsx")
#View(AHORA12)
summary(AHORA12)
dim(AHORA12)

#Desactivar notacion cientifica
options(scipen = 999)


#Solicitamos descriptivas
library(pastecs)
Descriptivas<-stat.desc(AHORA12,basic = TRUE)


#MATRIZ DE CORRELACIONES
library(corrplot)
R<-cor(AHORA12[2:15],method = "pearson")
testRes = cor.mtest(R,conf.level=0.95)
corrplot(R,p.mat = testRes[[1]],sig.level = 0.05, type = "lower")


#TEST DE ESFERICIDAD DE BARLET
library(psych)
cortest.bartlett(R,n=32)

#NUMERO DE COMPONENTES PRINCIPALES A EXTRAER 
#Criterio del autovalor superior a la unidad 
library(FactoMineR)
library(factoextra)
fit<-PCA(AHORA12[2:31],scale.unit=TRUE,ncp=10,graph=TRUE)
fit$eig
#Grafico con colores
fviz_pca_var(fit, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE
)



#SCREE PLOT
library(factoextra)
fviz_eig(fit,addlabels = TRUE, ylim = c(0, 100))+
  theme_grey()

#INTERPRETACION DE LAS COMPONENTES PRINCIPALES


#PCA individuales
library(ggplot2)
library(ggrepel)
datos.grafico2<-data.frame(fit$var$coord[,1:2])
ggplot(datos.grafico2)+
  geom_point(aes(x=Dim.1,y=Dim.2,colour="darkred"))+
  geom_text_repel(aes(x=Dim.1,y=Dim.2),
                  label=rownames(datos.grafico2))+
  geom_vline(xintercept=0,colour="darkgray")+
  geom_hline(yintercept = 0,colour="darkgray")+
  labs(x="Dimension 1 (78%)", y = "Dimension 2 (12,1%) ")+
  theme(legend.position="none")



dimnames(AHORA12)
rownames(fit[1,])<-c(AHORA12$Provincia)
fviz_pca_ind(fit, pointsize = "cos2",
             pointshape = 21, fill = "#E7B800",
             repel = TRUE
            
)


#Calcular autovalores y autovectores de la matriz de correlaciones
library(corrplot)
S<-cor(AHORA12[,-1])
eigen(S)

Autovalores_Autovectores<-eigen(S)
rownames(Autovalores_Autovectores$vectors)<-c("Alimentos","Anteojos","Artefactos de iluminaci?n",	
                                              "Art?culos de Librer?a",	"Balnearios",	"Bicicletas",	
                                              "Calzado y Marroquiner?a",	"Colchones",	"Computadoras",	
                                              "Electrodom?sticos",	"Equipamiento m?dico",	"Indumentaria",
                                              "Instrumentos musicales",	"Juguetes",	"Libros",	
                                              "M?quinas y Herramientas",	
                                              "Materiales para la construcci?n",	
                                              "Medicamentos",	"Motocicletas",	
                                              "Muebles",	"Neumaticos",	"Perfumeria",	"Servicios de cuidado personal",	
                                              "Servicios de instalacion de alarmas",	"Servicios de organizacion de eventos",
                                              "Servicios deportivos",	"Servicios educativos",	"Servicios tecnicos",	
                                              "Talleres de reparacion",	"Turismo"
)

colnames(Autovalores_Autovectores$vectors)<-c("PC1","PC2","PC3","PC4","PC5","PC6",
                                              "PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15",
                                              "PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25",
                                              "PC26","PC27","PC28","PC29","PC30"
                                              )

Autovalores_Autovectores

#Calcular las componentes principales 
AHORA12.pc<-princomp(S,cor=TRUE)
AHORA12.pc


#REPRESENTACION DE LOS OBJETOS (PROVINCIAS)
datos.grafico<-data.frame(fit$var$coord[,1:2],AHORA12$Provincia)
colnames(datos.grafico)<-c("Dim.1","Dim.2","provincia")
ggplot(datos.grafico)+
  geom_point(aes(x=Dim.1, y=Dim.2, colour="darkred"))+
  geom_text_repel(aes(x=Dim.1,y=Dim.2),
                  label=datos.grafico$provincia)+
  geom_vline(xintercept=0,colour="darkgray")+
  geom_hline(yintercept=0,colour="darkgray")+
  labs(x="Dimension 1 (78%)",y="Dimension 2 (12,1%)")+
  theme(legend.position="none")

#REPRESENTACION CONJUNTA: BIPLOT
remotes::install_github('vqv/ggbiplot', force=TRUE)
library(ggbiplot)
library(plyr)
library(scales)
library(grid)
ggbiplot(fit)+
  scale_color_discrete(name='')+
  expand_limits(x=c(-3.5,1.5),y=c(-2,2))+
  labs(x="Dimension 1 (78%)",y="Dimension 2 (12,1%)")+
  geom_text_repel(label=AHORA12$Provincia,size=3)


fviz_pca_biplot(fit,
                geom.ind = "point",
                fill.ind = AHORA12$Provincia, col.ind = "black",
                pointshape = 21, pointsize = 2,
                palette = "jco",
                addEllipses = TRUE,
                alpha.var ="contrib", col.var = "contrib",
                gradient.cols = "RdYlBu",
                
                legend.title = list(fill = "Provincia", color = "Contrib",
                                    alpha = "Contrib"))


#exporto tabla de descriptivas
write.csv2(x = Descriptivas, 
           file = "Descriptivas.csv", 
           row.names = TRUE) 

getwd()



