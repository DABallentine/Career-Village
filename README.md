# Career Village - Matching Users with Professionals
This project is an adaptation of a <a href="https://www.kaggle.com/c/data-science-for-good-careervillage">Kaggle competition</a> to serve as a course project for Advanced Business Analytics, DSBA 6211, at the University of North Carolina and Charlotte for the Fall 2021 Semester. 

<b>Team Members:</b> <br>
Dave Collins <br>
Kristie Soliman <br>
Jaime Cassell <br>
Taylor Ferguson <br>
Matt Flynn <br>
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
(insert image 3) <br>
(insert image 4) <br>

##### International Users
Although the majority of users are based in the United States, the international users as a group make a significant subset of the total population as shown in the graphs above. The plots below break out the top 7 other countries of origin for both professionals and students. (Add note about disparity between professionals and students?). <br>
![image](https://user-images.githubusercontent.com/78170609/140662498-906c6cd0-ca7d-4e3d-b664-831e290474ec.png) <br>
![image](https://user-images.githubusercontent.com/78170609/140662517-aecfa497-bc59-4822-bd19-5ae9b589f66c.png) <br>

## Data Preparation for Modeling
## Modeling
## Evaluation
## Results
## Future Work
### Possible future work may include:
<ol>
  <li>Future work</li>
</ol>
