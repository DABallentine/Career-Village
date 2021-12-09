# Career Village - Matching Users with Professionals
This project is an adaptation of a <a href="https://www.kaggle.com/c/data-science-for-good-careervillage">Kaggle competition</a> to serve as a course project for Advanced Business Analytics, DSBA 6211, at the University of North Carolina and Charlotte for the Fall 2021 Semester. 

<b>Team Members:</b> <br>
Dave Collins <br>
Kristie Soliman <br>
Jaime Cassell <br>
Taylor Ferguson <br>
Dustin Ballentine <br>

## Project Summary
CareerVillage.org is a nonprofit that crowdsources career advice for underserved youth. Founded in 2011 in four classrooms in New York City, the platform has now served career advice from 25,000 volunteer professionals to over 3.5M online learners. The platform uses a Q&A style similar to StackOverflow or Quora to provide students with answers to any question about any career. 
## Research Objectives
<ol>
  <li> Explore User Profiles </li>
  <li> Explore Activities Time Series </li>
  <li> Explore Questions and Answers </li>
  <li> What factors motivate user participation? </li>
  <li> What factors affect a question’s likelihood to be answered? </li>
</ol>

## Data Resources
Data was retrieved from the <a href="https://www.kaggle.com/c/data-science-for-good-careervillage/overview"> Kaggle competition page </a> 
on 16 September, 2021. Five years worth of data was provided by CareerVillage.org. The data consists of 15 csv files, 1 file per entity. The Enhanced Entity Relationship Diagram below approximates the relationships amongst the original 15 tables.
![image](https://user-images.githubusercontent.com/78170609/140662835-169f9641-38e1-4190-98fe-d08187b97532.png)

## Data Preprocessing
### Initial preprocessing by entity
We began preprocessing each table individually, to include data type conversions, formatting changes, transformations, and new feature engineering. A summary of the major steps performed for each table is provided below:
<ol>
<li> answers </li>
<li> comments </li>
<li> emails </li>
<li> group_memberships </li>
<li> groups </li>
<li> matches </li>
<li> professionals </li>
- Created variable professionals_loc_div by binning professionals location into U.S. Geographic Division <br>
- Created variable professionals_country by binning professionals location into country <br>
- Transformed professionals_date_joined into datetime, and removes hh:mm:ss <br>
- Imputed "Not Specified" for NA fields <br>
<li> questions </li>
<li> school_memberships </li>
<li> students </li>
- Created variable students_loc_div by binning students location into U.S. Geographic Division <br>
- Created variable students_country by binning students location into country <br>
- Transformed students_date_joined into datetime, and removes hh:mm:ss <br>
- Imputed "Not Specified" for NA fields <br>
<li> tag_questions </li>
<li> tag_users </li>
<li> tags </li>
<li> question_scores </li>
<li> answer_scores </li>
</ol>

### Subsequent preprocessing by data subset

## Data Understanding and Exploration
### 1. Exploring User Profiles
#### Locations 
##### U.S.-based Users
More than 90% of each population are from the United States, although  Another significant category of users are those who choose not to enter any location information, or who entered clearly erroneous information, both of which we have rolled into one category of "Not Specified". Since the choice to leave the field blank is up to the user, these records may provide valuebale information regarding user behavior. <br>
![professionals_Map](https://user-images.githubusercontent.com/93226184/143082977-ad63d73e-dcbe-48e5-b8f7-e5bcb5200685.jpeg) <br>
![students_Map](https://user-images.githubusercontent.com/93226184/143082899-8fb705a9-8b71-48f6-9cd9-219419454a30.jpeg) <br>

##### International Users
Although the majority of users are based in the United States, the international users as a group make a significant subset of the total population as shown in the graphs above. The plots below break out the top 7 other countries of origin for both professionals and students. As the charts below highlight, whereas a majority of both international professionals and students come from India, international professionals appear to have a higher presence in China and Europe, while more international students are in Africa. <br> <br>
![image](https://user-images.githubusercontent.com/78170609/140662498-906c6cd0-ca7d-4e3d-b664-831e290474ec.png) <br>
![image](https://user-images.githubusercontent.com/78170609/140662517-aecfa497-bc59-4822-bd19-5ae9b589f66c.png) <br>

#### Industries

![Professionals' Industries](https://user-images.githubusercontent.com/78170609/145463621-749653e2-c129-4e73-9e6c-339c1f4f3f58.png) <br>
![Industries Providing Answers](https://user-images.githubusercontent.com/78170609/145463669-550c4e1f-c86b-40e9-81f2-bc3cee15d59c.png) <br>

### 2. Exploring Activity Time Series

### 3. Exploring Questions and Answers

## Modeling

### 4. What factors motivate users' participation?
#### Defining participation / activity

#### a. Factors motivating professionals

#### b. Factors motivating students

### 5. What factors affect a question's likelihood to be answered?

## Results Summary
## Future Work
### Possible future work may include:
<ol>
  <li>Future work</li>
</ol>
