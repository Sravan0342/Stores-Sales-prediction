# Setting up and getting the working directory

#setwd("C:\\Users\\OneDrive\\Desktop\\R_Codes") 
#setwd()

setwd("D:/STATS/PROJECT/FINAL")
#getwd()

# Loading the libraries 

library(Amelia)
library(ggplot2)
library(caret)
library(tidyverse)
library(caTools)
library(magrittr) 
library(scales)
library(dplyr)
library(car)
library(tidyr)
library(janitor)
library(psych)
library(caret)

# Reading the store_cleaned_2 

store<-read.csv("Store.csv")
store

# Missing values

is.na(store)
 
sum(is.na(store)) # There are no missing values

colSums(is.na(store))

# Cleaning the store_cleaned_2

store_1<-clean_names(store)

store_2<-remove_empty(store_1, which = c("rows","cols"), quiet = FALSE)
store_2

store_cleaned_2<-distinct(store_2)
store_cleaned_2

#View(store_cleaned_2)

# Running the summary, str, head, tail and class command

summary(store_cleaned_2)
str(store_cleaned_2)
head(store_cleaned_2)
tail(store_cleaned_2)
class(store_cleaned_2)

# Factorization 

store_cleaned_2$location<-as.factor(store_cleaned_2$location)
store_cleaned_2$customer_type<-as.factor(store_cleaned_2$customer_type)
store_cleaned_2$gender<-as.factor(store_cleaned_2$gender)
store_cleaned_2$category<-as.factor(store_cleaned_2$category)
store_cleaned_2$mode_of_payment<-as.factor(store_cleaned_2$mode_of_payment)

str(store_cleaned_2)

length(store_cleaned_2)

location_counts<- table(store_cleaned_2$location)

print(location_counts)

colours<-c("red","green","blue")

barplot(location_counts, col = c("red","green","blue"))

length(location_counts)

which.max(store_cleaned_2$total)
which.max(store_cleaned_2$location)


hist(store_cleaned_2$total)

ggplot(store_cleaned_2, aes(x = total, y = location, color = location)) + 
  geom_point() + 
  xlab("total") + 
  ylab("location") +
  ggtitle("Total vs Location")

ggplot(store_cleaned_2, aes(x = location,y= total, color = location)) + geom_boxplot()

aggregate(store_cleaned_2$total,list(store_cleaned_2$location),FUN=sum) %>% ggplot(aes(x="",y=x,fill=Group.1)) + 
  geom_bar(width=1,stat="identity") + coord_polar("y",start=0)

# Barplot for gender and category
counts<-table(store_cleaned_2$gender,store_cleaned_2$category);counts

rownames(counts)

barplot(counts,main = "Gender vs Category",xlab = 'Gender',ylab = 'Category',
        col = c("Orange","Red"), legend=rownames(counts),beside = T)

# Barplot for customer type and mode of payment
counts_1<-table(store_cleaned_2$customer_type,store_cleaned_2$mode_of_payment);counts_1

rownames(counts_1)

barplot(counts_1,main = "Customer Type vs Mode of Payment",xlab = 'Mode of Payment',ylab = 'Customer Type',
        col = c("Blue","Green"), legend=rownames(counts_1),beside = T)


# Barplot for category and location
counts_2<-table(store_cleaned_2$category,store_cleaned_2$location);counts_2

rownames(counts_2)

barplot(counts_2,main = "Location vs Category",xlab = 'Location',ylab = 'Category',
        col = c("Blue","Green","Red","Orange","Yellow"), legend=rownames(counts_2),beside = T)

# Barplot for gender and location
counts_3<-table(store_cleaned_2$gender,store_cleaned_2$location);counts_3

rownames(counts_3)

barplot(counts_3,main = "Gender vs Location",xlab = 'Location',ylab = 'Gender',
        col = c("Orange","Maroon"), legend=rownames(counts_3),beside = T)

length(store_cleaned_2$quantity)
length(store_cleaned_2$mode_of_payment)

dev.off()

plot(store_cleaned_2$quantity,store_cleaned_2$gross_income,pch=12,
     col="maroon",xlab = "Quantity",
     ylab = "Gross Income")

scatter.smooth(store_cleaned_2$quantity,store_cleaned_2$gross_income,pch=1,col="blue",xlab = "Quantity",
               ylab = "Gross Income",
               main="Quantity vs Gross Income")

#ggplot(store_cleaned_2, aes(x = total, y = mode_of_payment, fill = mode_of_payment)) +
  #geom_bar(stat = "identity") +
  #labs(title = "My Bar Plot", x = "Categories", y = "Values") +
  #scale_fill_manual(values = c("red", "blue", "green"))

cor(store_cleaned_2$quantity,store_cleaned_2$gross_income)
# Model creation

siso<-lm(total~price_unit,data = store_cleaned_2);summary(siso)

miso_main<-lm(total~price_unit+quantity,data=store_cleaned_2);summary(miso_main)

#2-test no star for location
miso_2<-lm(total~price_unit+quantity+location,data=store_cleaned_2);summary(miso_2)

#3-test no star for time
miso_3<-lm(total~price_unit+quantity+time,data=store_cleaned_2);summary(miso_3)

#4-might work
#miso_4<-lm(total~price_unit+gross_income,data=store_cleaned_2);summary(miso_4)

#5-no star for rating points
miso_5<-lm(total~price_unit+gross_income+rating_points,data=store_cleaned_2);summary(miso_5)

miso_6<-lm(total~.,data = store_cleaned_2);summary(miso_6)

#par(mfrow = c(2, 2))
#plot(miso_main, ask=FALSE)
summary(miso_main)

pairs.panels(store_cleaned_2,gap=1,bg=c("red","green","blue")[store_cleaned_2$total],pch=21)

AIC(miso_main)
AIC(miso_2)
AIC(miso_3)
AIC(miso_5)
AIC(miso_6)

control <- trainControl(method="cv", number=10)
metric <- "RMSE"

# Advance Model

linear_regression<-glm(total~price_unit+quantity,data=store_cleaned_2)
summary(linear_regression)


str(store_cleaned_2)
store_cleaned_2= subset(store_cleaned_2,select=-c(time,date))


# decision tree
set.seed(7)
fit.cart <- train(total~., data=store_cleaned_2, method="rpart",metric=metric, trControl=control)
# Random Forest
set.seed(7)
fit.rf <- train(total~., data=store_cleaned_2, method="rf",metric=metric, trControl=control)
# kNN
set.seed(7)
fit.knn <- train(total~., data=store_cleaned_2, method="knn",metric=metric, trControl=control)



# summarize accuracy of models
results <- resamples(list(cart=fit.cart, knn=fit.knn, rf=fit.rf))#,nn =fit.nn))
summary(results)
#making prediction
predict(fit.cart)
predict(fit.rf)
predict(fit.knn)
