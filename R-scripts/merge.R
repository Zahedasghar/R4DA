#Data manipulation
library(dplyr)

# Dataframe 1:
personal_details = data.frame(Student_ID = c(1:5), Name = c("Sadia", "Beenish", "Nisar", "Anand", "Farooq"), Address = c("Karach", "Karachi", "Peshawar", "Multan", "Naushera"))

#Dataframe 2:
courses = data.frame(Student_ID = c(2,3,5,8), Course = c("History", "Economics", "Law", "Sociology"))

print(personal_details)
print(courses)


# left_join(x , y, by = ) 

left_join(personal_details,courses,by="Student_ID")

full_join(x=personal_details,y=courses,by="Student_ID")

left_join(x=personal_details,y=courses,by="Student_ID")

right_join(x=personal_details,y=courses,by="Student_ID")
