# Career Village - Matching Users with Professionals
This project is an adaptation of a <a href="https://www.kaggle.com/c/data-science-for-good-careervillage">Kaggle competition</a> to serve as a course project for Advanced Business Analytics, DSBA 6211, at the University of North Carolina and Charlotte for the Fall 2021 Semester. 

<b>Team Members:</b> <br>
Dave Collins <br>
Kristie Soliman <br>
Jaime Cassell <br>
Taylor Ferguson <br>
Matt Flynn <br>
Dustin Ballentine <br>

<h2> Project Summary </h2>
CareerVillage.org is a nonprofit that crowdsources career advice for underserved youth. Founded in 2011 in four classrooms in New York City, the platform has now served career advice from 25,000 volunteer professionals to over 3.5M online learners. The platform uses a Q&A style similar to StackOverflow or Quora to provide students with answers to any question about any career. 
<h2> Research Objectives </h2>
<ol>
  <li> Explore User Profiles </li>
  <li> Explore Activities Time Series </li>
  <li> Explore Questions and Answers </li>
  <li> What factors motivate user participation? </li>
  <li> What factors affect a question’s likelihood to be answered? </li>
</ol>
<h2> Data Resources </h2>
Data was retrieved from the <a href="https://www.kaggle.com/c/data-science-for-good-careervillage/overview"> Kaggle competition page </a> 
on 16 September, 2021. Five years worth of data was provided by CareerVillage.org.

<h2> Data Preprocessing </h2>
<h3> Initial preprocessing by entity </h3>
We began preprocessing each table individually, to include data type conversions, formatting changes, transformations, and new feature engineering. A summary of the major steps performed for each table is provided below:
<ol>
<li> answers </li>
<li> comments </li>
<li> emails </li>
<li> group_memberships </li>
<li> groups </li>
<li> matches </li>
<li> professionals </li>
* Created variable professionals_loc_div by binning professionals location into U.S. Geographic Division <br>
* Created variable professionals_country by binning professionals location into country <br>
* Transformed professionals_date_joined into datetime, and removes hh:mm:ss <br>
* Imputed "Not Specified" for NA fields <br>
<li> questions </li>
<li> school_memberships </li>
<li> students </li>
* Created variable students_loc_div by binning students location into U.S. Geographic Division <br>
* Created variable students_country by binning students location into country <br>
* Transformed students_date_joined into datetime, and removes hh:mm:ss <br>
* Imputed "Not Specified" for NA fields <br>
<li> tag_questions </li>
<li> tag_users </li>
<li> tags </li>
<li> question_scores </li>
<li> answer_scores </li>
</ol>

<h3> Subsequent preprocessing by data subset </h3>

<h2> Data Understanding and Exploration </h2>
<h3> 1. Exploring User Profiles </h3>
<h4> Locations </h4> 
More than 90% of each population are from the United States, and the plots below show the top 7 other countries of origin for both professionals and students. 

<h2> Data Preparation for Modeling </h2>
<h2> Modeling </h2>
<h2> Evaluation </h2>
<h2> Results </h2>
<h2> Future Work </h2>
<h3> Possible future work may include:</h3>
<ol>
  <li>Future work</li>
</ol>
