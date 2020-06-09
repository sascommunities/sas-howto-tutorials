
#################
# Impute the data
#################

# Load
df <- read.csv(file="D:/Workshop/Winsas/UA19DMMM/hmeq.csv", header=TRUE, sep=",")
head(df)
dim(df)

# Missing
sum(is.na(df) | df=="") # 5271

# Interval
sum(is.na(df$MORTDUE))
sum(is.na(df$VALUE))
sum(is.na(df$YOJ))
sum(is.na(df$DEROG))
sum(is.na(df$DELINQ))
sum(is.na(df$CLAGE))
sum(is.na(df$NINQ))
sum(is.na(df$CLNO))
sum(is.na(df$DEBTINC))

# Nominal
sum(df$REASON=="")
table(df$REASON)
sum(df$JOB=="")
table(df$JOB)

# Impute Interval
df$MORTDUE[is.na(df$MORTDUE)] = mean(df$MORTDUE,na.rm=T)
df$VALUE[is.na(df$VALUE)] = mean(df$VALUE,na.rm=T)
df$YOJ[is.na(df$YOJ)] = mean(df$YOJ,na.rm=T)
df$DEROG[is.na(df$DEROG)] = mean(df$DEROG,na.rm=T)
df$DELINQ[is.na(df$DELINQ)] = mean(df$DELINQ,na.rm=T)
df$CLAGE[is.na(df$CLAGE)] = mean(df$CLAGE,na.rm=T)
df$NINQ[is.na(df$NINQ)] = mean(df$NINQ,na.rm=T)
df$CLNO[is.na(df$CLNO)] = mean(df$CLNO,na.rm=T)
df$DEBTINC[is.na(df$DEBTINC)] = mean(df$DEBTINC,na.rm=T)

# Impute Nominal
df$REASON[df$REASON==""] = names(which(table(df$REASON)==max(table(df$REASON))))
df$JOB[df$JOB==""] = names(which(table(df$JOB)==max(table(df$JOB))))

# Missing?
sum(is.na(df) | df=="") # 0

# Partition Data
nr = nrow(df)
set.seed(802)
rows = sample(c(rep(1,nr*.6), rep(0,nr*.3), rep(2, nr*.1)))
train_rows = which(rows==1)
valid_rows = which(rows==0)
test_rows =  which(rows==2)

df_train = df[train_rows,]
df_valid = df[valid_rows,]
df_test  = df[test_rows,]

# Logistic Regression Model
mymod = glm(BAD ~ LOAN + MORTDUE + VALUE + REASON + JOB + YOJ + DEROG + DELINQ + CLAGE + NINQ + CLNO + DEBTINC, data=df_train, family = "binomial")

# Markup
library(pmml)
saveXML(pmml(mymod),"D:/Workshop/Winsas/UA19DMMM/R_Logistic_Regression_Model.xml")

#####################
# JSON - R - FitStats
#####################

library(rjson)
json = fromJSON(file = "D:/Workshop/Winsas/UA19DMMM/dmcas_fitstat_sas.json")

# Calculate ASE statistics
train_probs = predict(mymod, df_train, type = "response")
valid_probs = predict(mymod, df_valid, type = "response")
test_probs =  predict(mymod, df_test,  type = "response")

train_ASE = mean((df_train$BAD - train_probs)^2)
valid_ASE = mean((df_valid$BAD - valid_probs)^2)
test_ASE  = mean((df_test$BAD  - test_probs)^2)

# Calculate C statistics
library(pROC)

train_C = as.numeric(gsub("Area under the curve: ", "", auc(df_train$BAD, train_probs)))
valid_C = as.numeric(gsub("Area under the curve: ", "", auc(df_valid$BAD, valid_probs)))
test_C  = as.numeric(gsub("Area under the curve: ", "", auc(df_test$BAD,  test_probs)))

# Test
json$data[[1]]$dataMap$`_RASE_` = paste0(round(sqrt(test_ASE),4))
json$data[[1]]$dataMap$`_ASE_` = paste0(round(test_ASE,4))
json$data[[1]]$dataMap$`_C_` = paste0(round(test_C,4))

#Train
json$data[[2]]$dataMap$`_RASE_` = paste0(round(sqrt(train_ASE),4))
json$data[[2]]$dataMap$`_ASE_` = paste0(round(train_ASE,4))
json$data[[2]]$dataMap$`_C_` = paste0(round(train_C,4))

# Valid
json$data[[3]]$dataMap$`_RASE_` = paste0(round(sqrt(valid_ASE),4))
json$data[[3]]$dataMap$`_ASE_` = paste0(round(valid_ASE,4))
json$data[[3]]$dataMap$`_C_` = paste0(round(valid_C,4))

# Export to json file
export_json = rjson::toJSON(json, indent=1)
write(export_json, "D:/Workshop/Winsas/UA19DMMM/dmcas_fitstat.json")

################
# JSON - R - ROC
################

library(rjson)
json = fromJSON(file = "D:/Workshop/Winsas/UA19DMMM/dmcas_roc_sas.json")

# Remove the Validation and test ROC data
for(i in rev(23:length(json$data))){
  json$data[[i]]=NULL
}

# Get Predictions
preds = predict(mymod,df_train,type = "response")
target = df_train$BAD

# Create Confusion Matrices to get ROC curve information
myseq = seq(.05,.95,.05)
sens = NULL
spec = NULL

for(i in 1:length(myseq)){
  temp = (preds>myseq[i])*1
  tab = table(target,temp)
  sens = c(sens, tab[2,2]/(tab[2,2]+tab[2,1]))
  spec = c(spec, tab[1,1]/(tab[1,1]+tab[1,2]))
}

myseq = c(0,myseq,1)
sens = c(1,sens,0)
spec = c(0,spec,1)
plot(1-spec,sens)

# Add R values
for(i in 1:21){
  json$data[[i]]$dataMap$`_OneMinusSpecificity_` = paste0(1-spec[i])
  json$data[[i]]$dataMap$`_Sensitivity_` = paste0(sens[i])
  json$data[[i]]$dataMap$`_Specificity_` = paste0(spec[i])
}

# Export to json file
export_json = rjson::toJSON(json, indent=1)
write(export_json, "D:/Workshop/Winsas/UA19DMMM/dmcas_roc.json")
















