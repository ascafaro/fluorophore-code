setwd("/Users/u5036696/Desktop")
library(readxl)
input<- readline(prompt = "what is the raw data file name minus the extension:")
input.meta<-readline(prompt = "what is the metadata file name minus the extension:")
raw.data<-as.data.frame(read_excel(paste(input,".xls", sep = ''),skip = 20, col_names = TRUE))
n.raw.data<-nrow(raw.data)
raw.data.clean<-raw.data[-(n.raw.data),]
par(mfrow=c(2,3))

O2.consumption<-Filter(function(x) {!all(is.na(x))}, raw.data.clean)
n<-ncol(O2.consumption)
r<-nrow(O2.consumption)
O2.consumption.curves<-(O2.consumption[,(7:n)])
matplot(O2.consumption$HRS,O2.consumption.curves, xlab = "Time (Hours)", ylab = "O2 as fraction of O2 in air", type = "l", col = c("red","red","blue", "blue", rep("green",n))) 
time<-O2.consumption$HRS
f<-function(x){as.numeric(x)}
#O2.consumption.df<-as.data.frame(O2.consumption.curves)

metadata<-as.data.frame(read_excel(paste(input.meta,".xlsx",sep = ''), col_names = TRUE),na=NULL)
metadata.cropped<-metadata[(1:(n-6)),]

leaf.area<-as.numeric(metadata.cropped$Area_cm2)
fresh.weight<-as.numeric(metadata.cropped$Fresh_Weight_g)
dry.weight<-as.numeric(metadata.cropped$Dry_Weight_g)

altitude<- c(568) # in metres above see level
pressure_MSL<- metadata.cropped$pressure_kPa[1] #http://www.bom.gov.au/products/IDN60903/IDN60903.94926.shtml
pressure<- pressure_MSL-(101.35*(1-(1-(altitude/44307.69231))^5.25328)) # in KPa
O2_fraction<- (20.95/100) 
temp<-metadata.cropped$temperature[1] # to be set depending on temp measured at

tube.volume<-metadata.cropped$tube_vol_mL[1] #what is tube volume in mL
liq_vol<-metadata.cropped$liq_vol_mL[1] # amount of RO water added to tube in ml
leaf_vol<-metadata.cropped$leaf_thickness_um[1]/1000000*leaf.area # converted from um input to cm
air_vol<-tube.volume-liq_vol-leaf_vol
gas.constant<-c(8314) # # cm3/kPa/K/mol
A<-(O2.consumption.curves$C1) 
if (mean(A) > 1.1) {A<-(O2.consumption.curves$D1)}
N<-(O2.consumption.curves$A1)
if (mean(N) > 0.1) {N<-(O2.consumption.curves$B1)}
N<- O2.consumption.curves$A1
A.N.range<-A-N


O2_fraction_function <- function (x) {(O2.consumption.curves[x,]/A.N.range)*O2_fraction}
O2_f <- as.data.frame(sapply(1:r, O2_fraction_function))
O2_f<-as.data.frame(t(O2_f))
O2_f<-sapply(O2_f,f)

O2_conc_gas_phase_f<-function(x) {pressure*(O2_f[x,]*air_vol/(8314*(273.15+temp)))*1000000} # umols of O2 in gas phase of tube 
O2_conc_gas_phase<-as.data.frame(sapply(1:r, O2_conc_gas_phase_f))
O2_conc_gas_phase<-as.data.frame(t(O2_conc_gas_phase))
O2_f<-sapply(O2_conc_gas_phase,f)

KH<- c(769.23) # Henry's solubility constant at 25 degrees in mol/L/101.3 kPa (1Atm)
pressure_adj <- (pressure/101.3)

tk <- temp+273.15
changesolH_R <- c(1700) # enthalopy of dissolution
#H_T <- O2_con_25_umol_mL*exp(changesolH_R*((1/tk)-(1/298.15)))*1000 # umol mL

O2_con_umol_liq_f <- function (x) {(O2_f[x,]/KH)*exp(changesolH_R*((1/tk)-(1/298.15)))*1000000/1000*pressure_adj*liq_vol} # umol O2 in volume of liquid @ temp
O2_con_umol_liq <- as.data.frame(sapply(1:r, O2_con_umol_liq_f))
O2_con_umol_liq<-as.data.frame(t(O2_con_umol_liq))
O2_con_umol_liq<-as.data.frame(sapply(O2_con_umol_liq,f))

O2_con_expelled.fun<-function(x){O2_con_umol_liq[1,]-O2_con_umol_liq[x,]} 
O2_con_expelled<-as.data.frame(sapply(1:r,O2_con_expelled.fun))
O2_con_expelled<-as.data.frame(t(O2_con_expelled))
O2_con_expelled<-sapply(O2_con_expelled,f)

O2_conc_total <- as.data.frame(O2_conc_gas_phase - O2_con_expelled)

plot(time,O2_conc_gas_phase[,8], col="blue")
points(time, O2_conc_total[,8], col ="red")

plot(fresh.weight, dry.weight)


O2_conc <- O2_conc_total
time_O2_conc<- cbind(time,O2_conc)


colnames(time_O2_conc)<-c("time", metadata.cropped$`Sample Name`)
start.time<-as.numeric(readline(prompt = "what is the start point in hours of respiratory slope:"))
end.time<-as.numeric(readline(prompt = "what is the end point in hours of respiratory slope:"))
slope.range<-subset(time_O2_conc, time > start.time & time < end.time)
colnames(slope.range)<-c("time", metadata.cropped$`Sample Name`)



lm_func <- function(y) coef(lm(y ~ slope.range[,'time'], data = slope.range))[2]
slope_res<- (apply(slope.range, 2, lm_func))

slope_blank<-slope_res['Air_1'] 
if (slope_blank < -0.02) {slope_blank<-(slope_res['Air_2'])}

slope_N<-slope_res['Nitrogen_1']
if (slope_N > 0.02) {slope_N<-(slope_res['Nitrogen_2'])}

slope_res_corrected<-c(slope_res-slope_blank-slope_N)
respiration_slope<-c(-(slope_res_corrected[2:length(slope_res)]))
respiration_sec<-c(respiration_slope)/(60*60)

lm_func_f <- function(y)lm(y~slope.range[,'time'], data = slope.range[,(6:length(slope.range))])
plot_function <- function (x) {plot(slope.range$time,slope.range[,x], xlab = "Time (h)", ylab = "umol O2", pch=1,col = "blue")
  abline(lm_func_f(slope.range[,x])$coefficients[1],lm_func_f(slope.range[,x])$coefficients[2], col="red")}
plots<-sapply(6:8, plot_function)


respiration_area<-c(respiration_sec*(10000/leaf.area))                        
respiration_FM<-c(respiration_sec*(1/fresh.weight)*1000)
respiration_DM<-c(respiration_sec*(1/dry.weight)*1000)

results<-data.frame(metadata.cropped$`Sample Name`, metadata.cropped$`treatment`,respiration_slope,respiration_area,respiration_FM,respiration_DM)
names(results)<-c("Sample","Treatment","Respiration slope (µmol/h)","Respiration area (µmol/m2/s)", "Respiration fresh mass (nmol/g/s)", "Respiration dry mass (nmol/g/s)")
write.csv(results, file = paste(input,"results",start.time,"_",end.time,".csv", sep = ''))
