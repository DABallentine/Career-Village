Career Village - Matching Users with Professionals
================

## Notebook Summary

This notebook is our initial look at the data to identify what we have
to work with, what issues exist with the data in its current form, and
how the data can best be aggregated for this project. After reading in
the data, we follow the outline below: <br> - Observe table structures,
data types, and summary statistics, and identify key columns <br> -
Identify and address initial errors, missing values, variable
transformations, and feature engineering <br> - Aggregate required
feature sets <br>

------------------------------------------------------------------------

## 1. Read in the Data

``` r
# Locate and list files in the directory
file_list <- list.files(getwd(), full.names=T, pattern='*.csv')
filenames <- tools::file_path_sans_ext(basename(file_list))

# Read in all csv files into data frames
for (i in 1:length(file_list)) {
  df <- read.csv(file_list[i], header=T, na.strings=c('NA',''), encoding="UTF-8") # Using UTF-8 to include extended and non-Latin characters
  assign(filenames[i], df)
}
```

## 2a. Variable summaries

``` r
for (i in 1:length(filenames)) {
  cat(filenames[i], "\n", "\n")
  print(summary(get(as.name(filenames[i]))))
  cat('_______________________________________________________________________________________', "\n")
}
```

    ## answer_scores 
    ##  
    ##       id                score        
    ##  Length:51138       Min.   : 0.0000  
    ##  Class :character   1st Qu.: 0.0000  
    ##  Mode  :character   Median : 0.0000  
    ##                     Mean   : 0.4158  
    ##                     3rd Qu.: 1.0000  
    ##                     Max.   :30.0000  
    ## _______________________________________________________________________________________ 
    ## answers 
    ##  
    ##   answers_id        answers_author_id  answers_question_id answers_date_added
    ##  Length:51123       Length:51123       Length:51123        Length:51123      
    ##  Class :character   Class :character   Class :character    Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character    Mode  :character  
    ##  answers_body      
    ##  Length:51123      
    ##  Class :character  
    ##  Mode  :character  
    ## _______________________________________________________________________________________ 
    ## comments 
    ##  
    ##  comments_id        comments_author_id comments_parent_content_id
    ##  Length:14966       Length:14966       Length:14966              
    ##  Class :character   Class :character   Class :character          
    ##  Mode  :character   Mode  :character   Mode  :character          
    ##  comments_date_added comments_body     
    ##  Length:14966        Length:14966      
    ##  Class :character    Class :character  
    ##  Mode  :character    Mode  :character  
    ## _______________________________________________________________________________________ 
    ## emails 
    ##  
    ##    emails_id       emails_recipient_id emails_date_sent  
    ##  Min.   :    106   Length:1850101      Length:1850101    
    ##  1st Qu.: 881390   Class :character    Class :character  
    ##  Median :1400010   Mode  :character    Mode  :character  
    ##  Mean   :1362206                                         
    ##  3rd Qu.:1911846                                         
    ##  Max.   :2409829                                         
    ##  emails_frequency_level
    ##  Length:1850101        
    ##  Class :character      
    ##  Mode  :character      
    ##                        
    ##                        
    ##                        
    ## _______________________________________________________________________________________ 
    ## group_memberships 
    ##  
    ##  group_memberships_group_id group_memberships_user_id
    ##  Length:1038                Length:1038              
    ##  Class :character           Class :character         
    ##  Mode  :character           Mode  :character         
    ## _______________________________________________________________________________________ 
    ## groups 
    ##  
    ##   groups_id         groups_group_type 
    ##  Length:49          Length:49         
    ##  Class :character   Class :character  
    ##  Mode  :character   Mode  :character  
    ## _______________________________________________________________________________________ 
    ## matches 
    ##  
    ##  matches_email_id  matches_question_id
    ##  Min.   :    106   Length:4316275     
    ##  1st Qu.:1011924   Class :character   
    ##  Median :1544656   Mode  :character   
    ##  Mean   :1478192                      
    ##  3rd Qu.:1970643                      
    ##  Max.   :2409829                      
    ## _______________________________________________________________________________________ 
    ## prof_geo 
    ##  
    ##        X         professionals.professionals_location      lon         
    ##  Min.   :    1   Length:25054                         Min.   :-166.55  
    ##  1st Qu.: 6264   Class :character                     1st Qu.: -98.48  
    ##  Median :12528   Mode  :character                     Median : -84.39  
    ##  Mean   :12528                                        Mean   : -75.42  
    ##  3rd Qu.:18791                                        3rd Qu.: -74.01  
    ##  Max.   :25054                                        Max.   : 174.89  
    ##       lat        
    ##  Min.   :-41.29  
    ##  1st Qu.: 32.81  
    ##  Median : 37.77  
    ##  Mean   : 35.68  
    ##  3rd Qu.: 41.31  
    ##  Max.   : 71.29  
    ## _______________________________________________________________________________________ 
    ## professionals 
    ##  
    ##  professionals_id   professionals_location professionals_industry
    ##  Length:28152       Length:28152           Length:28152          
    ##  Class :character   Class :character       Class :character      
    ##  Mode  :character   Mode  :character       Mode  :character      
    ##  professionals_headline professionals_date_joined
    ##  Length:28152           Length:28152             
    ##  Class :character       Class :character         
    ##  Mode  :character       Mode  :character         
    ## _______________________________________________________________________________________ 
    ## professionals_prepped 
    ##  
    ##  professionals_id   professionals_location professionals_industry
    ##  Length:28152       Length:28152           Length:28152          
    ##  Class :character   Class :character       Class :character      
    ##  Mode  :character   Mode  :character       Mode  :character      
    ##                                                                  
    ##                                                                  
    ##                                                                  
    ##  professionals_headline professionals_date_joined professionals_loc_div
    ##  Length:28152           Length:28152              Length:28152         
    ##  Class :character       Class :character          Class :character     
    ##  Mode  :character       Mode  :character          Mode  :character     
    ##                                                                        
    ##                                                                        
    ##                                                                        
    ##  professionals_country total_answers     avg_ans_word_count avg_ans_num_sents
    ##  Length:28152          Min.   :   0.00   Min.   :  0.0      Min.   : 0.000   
    ##  Class :character      1st Qu.:   0.00   1st Qu.:  0.0      1st Qu.: 0.000   
    ##  Mode  :character      Median :   0.00   Median :  0.0      Median : 0.000   
    ##                        Mean   :   1.78   Mean   : 32.6      Mean   : 2.384   
    ##                        3rd Qu.:   1.00   3rd Qu.: 61.0      3rd Qu.: 4.000   
    ##                        Max.   :1710.00   Max.   :676.0      Max.   :85.000   
    ##  avg_ans_sent_length tot_words_written  professionals_acct_age
    ##  Min.   :  0.000     Min.   :     0.0   Min.   :   1.0        
    ##  1st Qu.:  0.000     1st Qu.:     0.0   1st Qu.: 184.0        
    ##  Median :  0.000     Median :     0.0   Median : 456.0        
    ##  Mean   :  5.937     Mean   :   174.1   Mean   : 592.6        
    ##  3rd Qu.: 12.535     3rd Qu.:    95.0   3rd Qu.: 968.0        
    ##  Max.   :346.000     Max.   :163638.0   Max.   :2676.0        
    ##  email_notification_daily email_notification_immediate
    ##  Min.   :  0.00           Min.   :   0.00             
    ##  1st Qu.:  0.00           1st Qu.:   0.00             
    ##  Median :  9.00           Median :   0.00             
    ##  Mean   : 52.86           Mean   :  11.84             
    ##  3rd Qu.: 59.00           3rd Qu.:   0.00             
    ##  Max.   :946.00           Max.   :3496.00             
    ##  email_notification_weekly tags_followed     total_hearts     
    ##  Min.   :  0.000           Min.   : 0.000   Min.   :  0.0000  
    ##  1st Qu.:  0.000           1st Qu.: 1.000   1st Qu.:  0.0000  
    ##  Median :  0.000           Median : 2.000   Median :  0.0000  
    ##  Mean   :  1.019           Mean   : 4.172   Mean   :  0.7208  
    ##  3rd Qu.:  0.000           3rd Qu.: 5.000   3rd Qu.:  0.0000  
    ##  Max.   :202.000           Max.   :82.000   Max.   :449.0000  
    ##  total_comments    
    ##  Min.   :   0.000  
    ##  1st Qu.:   0.000  
    ##  Median :   0.000  
    ##  Mean   :   1.932  
    ##  3rd Qu.:   1.000  
    ##  Max.   :2028.000  
    ## _______________________________________________________________________________________ 
    ## question_scores 
    ##  
    ##       id                score      
    ##  Length:23928       Min.   :  0.0  
    ##  Class :character   1st Qu.:  1.0  
    ##  Mode  :character   Median :  2.0  
    ##                     Mean   :  2.9  
    ##                     3rd Qu.:  3.0  
    ##                     Max.   :125.0  
    ## _______________________________________________________________________________________ 
    ## questions 
    ##  
    ##  questions_id       questions_author_id questions_date_added questions_title   
    ##  Length:23931       Length:23931        Length:23931         Length:23931      
    ##  Class :character   Class :character    Class :character     Class :character  
    ##  Mode  :character   Mode  :character    Mode  :character     Mode  :character  
    ##  questions_body    
    ##  Length:23931      
    ##  Class :character  
    ##  Mode  :character  
    ## _______________________________________________________________________________________ 
    ## questions_withTopics 
    ##  
    ##        X           text_id          questions_id       questions_author_id
    ##  Min.   :    1   Length:23931       Length:23931       Length:23931       
    ##  1st Qu.: 5984   Class :character   Class :character   Class :character   
    ##  Median :11966   Mode  :character   Mode  :character   Mode  :character   
    ##  Mean   :11966                                                            
    ##  3rd Qu.:17949                                                            
    ##  Max.   :23931                                                            
    ##                                                                           
    ##  questions_date_added questions_title    questions_body     text_cleaned      
    ##  Length:23931         Length:23931       Length:23931       Length:23931      
    ##  Class :character     Class :character   Class :character   Class :character  
    ##  Mode  :character     Mode  :character   Mode  :character   Mode  :character  
    ##                                                                               
    ##                                                                               
    ##                                                                               
    ##                                                                               
    ##    topic_lda    
    ##  Min.   :1.000  
    ##  1st Qu.:2.000  
    ##  Median :5.000  
    ##  Mean   :4.938  
    ##  3rd Qu.:7.000  
    ##  Max.   :9.000  
    ##  NA's   :86     
    ## _______________________________________________________________________________________ 
    ## school_memberships 
    ##  
    ##  school_memberships_school_id school_memberships_user_id
    ##  Min.   : 69421               Length:5638               
    ##  1st Qu.:125574               Class :character          
    ##  Median :196934               Mode  :character          
    ##  Mean   :167256                                         
    ##  3rd Qu.:198771                                         
    ##  Max.   :214607                                         
    ## _______________________________________________________________________________________ 
    ## students 
    ##  
    ##  students_id        students_location  students_date_joined
    ##  Length:30971       Length:30971       Length:30971        
    ##  Class :character   Class :character   Class :character    
    ##  Mode  :character   Mode  :character   Mode  :character    
    ## _______________________________________________________________________________________ 
    ## students_prepped 
    ##  
    ##  students_id        students_location  students_date_joined students_loc_div  
    ##  Length:30971       Length:30971       Length:30971         Length:30971      
    ##  Class :character   Class :character   Class :character     Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character     Mode  :character  
    ##                                                                               
    ##                                                                               
    ##                                                                               
    ##  students_country   students_acct_age tags_followed     school_mem_status
    ##  Length:30971       Min.   :   1.0    Min.   : 0.0000   Min.   :0.00000  
    ##  Class :character   1st Qu.: 387.0    1st Qu.: 0.0000   1st Qu.:0.00000  
    ##  Mode  :character   Median : 832.0    Median : 0.0000   Median :0.00000  
    ##                     Mean   : 818.7    Mean   : 0.6201   Mean   :0.04013  
    ##                     3rd Qu.:1000.5    3rd Qu.: 0.0000   3rd Qu.:0.00000  
    ##                     Max.   :2604.0    Max.   :56.0000   Max.   :2.00000  
    ##  total_questions   tot_words_written  total_hearts      total_comments  
    ##  Min.   : 0.0000   Min.   :   0.00   Min.   :   0.000   Min.   : 0.000  
    ##  1st Qu.: 0.0000   1st Qu.:   0.00   1st Qu.:   0.000   1st Qu.: 0.000  
    ##  Median : 0.0000   Median :   0.00   Median :   0.000   Median : 0.000  
    ##  Mean   : 0.7685   Mean   :  24.35   Mean   :   2.227   Mean   : 0.785  
    ##  3rd Qu.: 1.0000   3rd Qu.:  32.00   3rd Qu.:   3.000   3rd Qu.: 1.000  
    ##  Max.   :93.0000   Max.   :7032.00   Max.   :1102.000   Max.   :93.000  
    ## _______________________________________________________________________________________ 
    ## tag_questions 
    ##  
    ##  tag_questions_tag_id tag_questions_question_id
    ##  Min.   :   27        Length:76553             
    ##  1st Qu.:11165        Class :character         
    ##  Median :18360        Mode  :character         
    ##  Mean   :17290                                 
    ##  3rd Qu.:26420                                 
    ##  Max.   :39250                                 
    ## _______________________________________________________________________________________ 
    ## tag_users 
    ##  
    ##  tag_users_tag_id tag_users_user_id 
    ##  Min.   :   27    Length:136663     
    ##  1st Qu.:18065    Class :character  
    ##  Median :18807    Mode  :character  
    ##  Mean   :18972                      
    ##  3rd Qu.:24132                      
    ##  Max.   :39261                      
    ## _______________________________________________________________________________________ 
    ## tags 
    ##  
    ##   tags_tag_id    tags_tag_name     
    ##  Min.   :   27   Length:16269      
    ##  1st Qu.:21711   Class :character  
    ##  Median :31101   Mode  :character  
    ##  Mean   :28512                     
    ##  3rd Qu.:35207                     
    ##  Max.   :39276                     
    ## _______________________________________________________________________________________

## 2b. Count of NA values

``` r
for (i in 1:length(filenames)) {
  cat(filenames[i], "\n", "\n")
  print(sapply(get(as.name(filenames[i])), function(x) sum(is.na(x))))
  cat('_______________________________________________________________________________________', "\n")
}
```

    ## answer_scores 
    ##  
    ##    id score 
    ##     0     0 
    ## _______________________________________________________________________________________ 
    ## answers 
    ##  
    ##          answers_id   answers_author_id answers_question_id  answers_date_added 
    ##                   0                   0                   0                   0 
    ##        answers_body 
    ##                   1 
    ## _______________________________________________________________________________________ 
    ## comments 
    ##  
    ##                comments_id         comments_author_id 
    ##                          0                          0 
    ## comments_parent_content_id        comments_date_added 
    ##                          0                          0 
    ##              comments_body 
    ##                          4 
    ## _______________________________________________________________________________________ 
    ## emails 
    ##  
    ##              emails_id    emails_recipient_id       emails_date_sent 
    ##                      0                      0                      0 
    ## emails_frequency_level 
    ##                      0 
    ## _______________________________________________________________________________________ 
    ## group_memberships 
    ##  
    ## group_memberships_group_id  group_memberships_user_id 
    ##                          0                          0 
    ## _______________________________________________________________________________________ 
    ## groups 
    ##  
    ##         groups_id groups_group_type 
    ##                 0                 0 
    ## _______________________________________________________________________________________ 
    ## matches 
    ##  
    ##    matches_email_id matches_question_id 
    ##                   0                   0 
    ## _______________________________________________________________________________________ 
    ## prof_geo 
    ##  
    ##                                    X professionals.professionals_location 
    ##                                    0                                    0 
    ##                                  lon                                  lat 
    ##                                    0                                    0 
    ## _______________________________________________________________________________________ 
    ## professionals 
    ##  
    ##          professionals_id    professionals_location    professionals_industry 
    ##                         0                      3098                      2576 
    ##    professionals_headline professionals_date_joined 
    ##                      2067                         0 
    ## _______________________________________________________________________________________ 
    ## professionals_prepped 
    ##  
    ##             professionals_id       professionals_location 
    ##                            0                            0 
    ##       professionals_industry       professionals_headline 
    ##                            0                            0 
    ##    professionals_date_joined        professionals_loc_div 
    ##                            0                            0 
    ##        professionals_country                total_answers 
    ##                            0                            0 
    ##           avg_ans_word_count            avg_ans_num_sents 
    ##                            0                            0 
    ##          avg_ans_sent_length            tot_words_written 
    ##                            0                            0 
    ##       professionals_acct_age     email_notification_daily 
    ##                            0                            0 
    ## email_notification_immediate    email_notification_weekly 
    ##                            0                            0 
    ##                tags_followed                 total_hearts 
    ##                            0                            0 
    ##               total_comments 
    ##                            0 
    ## _______________________________________________________________________________________ 
    ## question_scores 
    ##  
    ##    id score 
    ##     0     0 
    ## _______________________________________________________________________________________ 
    ## questions 
    ##  
    ##         questions_id  questions_author_id questions_date_added 
    ##                    0                    0                    0 
    ##      questions_title       questions_body 
    ##                    0                    0 
    ## _______________________________________________________________________________________ 
    ## questions_withTopics 
    ##  
    ##                    X              text_id         questions_id 
    ##                    0                    0                    0 
    ##  questions_author_id questions_date_added      questions_title 
    ##                    0                    0                    0 
    ##       questions_body         text_cleaned            topic_lda 
    ##                    0                    0                   86 
    ## _______________________________________________________________________________________ 
    ## school_memberships 
    ##  
    ## school_memberships_school_id   school_memberships_user_id 
    ##                            0                            0 
    ## _______________________________________________________________________________________ 
    ## students 
    ##  
    ##          students_id    students_location students_date_joined 
    ##                    0                 2033                    0 
    ## _______________________________________________________________________________________ 
    ## students_prepped 
    ##  
    ##          students_id    students_location students_date_joined 
    ##                    0                    0                    0 
    ##     students_loc_div     students_country    students_acct_age 
    ##                    0                    0                    0 
    ##        tags_followed    school_mem_status      total_questions 
    ##                    0                    0                    0 
    ##    tot_words_written         total_hearts       total_comments 
    ##                    0                    0                    0 
    ## _______________________________________________________________________________________ 
    ## tag_questions 
    ##  
    ##      tag_questions_tag_id tag_questions_question_id 
    ##                         0                         0 
    ## _______________________________________________________________________________________ 
    ## tag_users 
    ##  
    ##  tag_users_tag_id tag_users_user_id 
    ##                 0                 0 
    ## _______________________________________________________________________________________ 
    ## tags 
    ##  
    ##   tags_tag_id tags_tag_name 
    ##             0             1 
    ## _______________________________________________________________________________________

### Initial decisions on missing values.

With no reasonable way to impute professionals’ or students’ missing
information, we will include the value “Not specified” in order to keep
those records and potentially discover trends that relate meaningfully
to users who chose not to enter those fields. Since the location field
is a combination of city and state or country which we will not use in
its current form, we will impute the “Not Specified” value into newly
engineered columns for US division.

We will simply drop the one tag with no name, and 1 answer with no body.
Further actions on missing values will be addressed as they arise later
when certain tables are merged.

## 2c. Variable structures

``` r
for (i in 1:length(filenames)) {
  cat(filenames[i], "\n", "\n")
  print(str(get(as.name(filenames[i]))))
  cat('_______________________________________________________________________________________', "\n")
}
```

    ## answer_scores 
    ##  
    ## 'data.frame':    51138 obs. of  2 variables:
    ##  $ id   : chr  "7b2bb0fc0d384e298cffa6afde9cf6ab" "7640a6e5d5224c8681cc58de860858f4" "3ce32e236fa9435183b2180fb213375c" "fa30fe4c016043e382c441a7ef743bfb" ...
    ##  $ score: int  1 5 2 0 2 1 1 3 3 1 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## answers 
    ##  
    ## 'data.frame':    51123 obs. of  5 variables:
    ##  $ answers_id         : chr  "4e5f01128cae4f6d8fd697cec5dca60c" "ada720538c014e9b8a6dceed09385ee3" "eaa66ef919bc408ab5296237440e323f" "1a6b3749d391486c9e371fbd1e605014" ...
    ##  $ answers_author_id  : chr  "36ff3b3666df400f956f8335cf53e09e" "2aa47af241bf42a4b874c453f0381bd4" "cbd8f30613a849bf918aed5c010340be" "7e72a630c303442ba92ff00e8ea451df" ...
    ##  $ answers_question_id: chr  "332a511f1569444485cf7a7a556a5e54" "eb80205482e4424cad8f16bc25aa2d9c" "eb80205482e4424cad8f16bc25aa2d9c" "4ec31632938a40b98909416bdd0decff" ...
    ##  $ answers_date_added : chr  "2016-04-29 19:40:14 UTC+0000" "2018-05-01 14:19:08 UTC+0000" "2018-05-02 02:41:02 UTC+0000" "2017-05-10 19:00:47 UTC+0000" ...
    ##  $ answers_body       : chr  "<p>Hi!</p>\n<p>You are asking a very interesting question.  I am giving you two sites that will give you some o"| __truncated__ "<p>Hi. I joined the Army after I attended college and received a Bachelor's Degree in Criminal Justice.  Commis"| __truncated__ "<p>Dear Priyanka,</p><p>Greetings! I have answered this question to Eshwari few days ago. I am going to reprodu"| __truncated__ "<p>I work for a global company who values highly international experience.  In fact, that is a key experience w"| __truncated__ ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## comments 
    ##  
    ## 'data.frame':    14966 obs. of  5 variables:
    ##  $ comments_id               : chr  "f30250d3c2ca489db1afa9b95d481e08" "ca9bfc4ba9464ea383a8b080301ad72c" "c354f6e33956499aa8b03798a60e9386" "73a6223948714c5da6231937157e4cb7" ...
    ##  $ comments_author_id        : chr  "9fc88a7c3323466dbb35798264c7d497" "de2415064b9b445c8717425ed70fd99a" "6ed20605002a42b0b8e3d6ac97c50c7f" "d02f6d9faac24997a7003a59e5f34bd3" ...
    ##  $ comments_parent_content_id: chr  "b476f9c6d9cd4c50a7bacdd90edd015a" "ef4b6ae24d1f4c3b977731e8189c7fd7" "ca7a9d7a95df471c816db82ee758f57d" "c7a88aa76f5f49b0830bfeb46ba17e4d" ...
    ##  $ comments_date_added       : chr  "2019-01-31 23:39:40 UTC+0000" "2019-01-31 20:30:47 UTC+0000" "2019-01-31 18:44:04 UTC+0000" "2019-01-31 17:53:28 UTC+0000" ...
    ##  $ comments_body             : chr  "First, you speak to recruiters. They are trained and knowledgable on all the requirements for each branch of se"| __truncated__ "Most large universities offer study abroad programs.  The study abroad programs are found on the schools websit"| __truncated__ "First, I want to put you at ease that the opposite can happen.  My dormmate that I was paired with my freshman "| __truncated__ "Your question submission was great! I just wanted to point out that if you break your original question into se"| __truncated__ ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## emails 
    ##  
    ## 'data.frame':    1850101 obs. of  4 variables:
    ##  $ emails_id             : int  2337714 2336077 2314660 2312639 2299700 2288533 2280818 2270520 2269277 2267396 ...
    ##  $ emails_recipient_id   : chr  "0c673e046d824ec0ad0ebe012a0673e4" "0c673e046d824ec0ad0ebe012a0673e4" "0c673e046d824ec0ad0ebe012a0673e4" "0c673e046d824ec0ad0ebe012a0673e4" ...
    ##  $ emails_date_sent      : chr  "2018-12-07 01:05:40 UTC+0000" "2018-12-06 01:14:15 UTC+0000" "2018-11-17 00:38:27 UTC+0000" "2018-11-16 00:32:19 UTC+0000" ...
    ##  $ emails_frequency_level: chr  "email_notification_daily" "email_notification_daily" "email_notification_daily" "email_notification_daily" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## group_memberships 
    ##  
    ## 'data.frame':    1038 obs. of  2 variables:
    ##  $ group_memberships_group_id: chr  "eabbdf4029734c848a9da20779637d03" "eabbdf4029734c848a9da20779637d03" "eabbdf4029734c848a9da20779637d03" "eabbdf4029734c848a9da20779637d03" ...
    ##  $ group_memberships_user_id : chr  "9a5aead62c344207b2624dba90985dc5" "ea7122da1c7b4244a2184a4f9f944053" "cba603f34acb4a40b3ccb53fe6681b5d" "fa9a126e63714641ae0145557a390cab" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## groups 
    ##  
    ## 'data.frame':    49 obs. of  2 variables:
    ##  $ groups_id        : chr  "eabbdf4029734c848a9da20779637d03" "7080bf8dcf78463bb03e6863887fd715" "bc6fc50a2b444efc8ec47111b290ffb8" "37f002e8d5e442ca8e36e972eaa55882" ...
    ##  $ groups_group_type: chr  "youth program" "youth program" "youth program" "youth program" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## matches 
    ##  
    ## 'data.frame':    4316275 obs. of  2 variables:
    ##  $ matches_email_id   : int  1721939 1665388 1636634 1635498 1620298 1618336 1610422 1601694 1568908 1551730 ...
    ##  $ matches_question_id: chr  "332a511f1569444485cf7a7a556a5e54" "332a511f1569444485cf7a7a556a5e54" "332a511f1569444485cf7a7a556a5e54" "332a511f1569444485cf7a7a556a5e54" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## prof_geo 
    ##  
    ## 'data.frame':    25054 obs. of  4 variables:
    ##  $ X                                   : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ professionals.professionals_location: chr  "New York, New York" "Boston, Massachusetts" "Milwaukee, Wisconsin" "New York, New York" ...
    ##  $ lon                                 : num  -77.9 -71.1 -87.9 -74 -72.9 ...
    ##  $ lat                                 : num  42.9 42.4 43 40.7 42.9 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## professionals 
    ##  
    ## 'data.frame':    28152 obs. of  5 variables:
    ##  $ professionals_id         : chr  "9ced4ce7519049c0944147afb75a8ce3" "f718dcf6d2ec4cb0a52a9db59d7f9e67" "0c673e046d824ec0ad0ebe012a0673e4" "977428d851b24183b223be0eb8619a8c" ...
    ##  $ professionals_location   : chr  NA NA "New York, New York" "Boston, Massachusetts" ...
    ##  $ professionals_industry   : chr  NA NA NA NA ...
    ##  $ professionals_headline   : chr  NA NA NA NA ...
    ##  $ professionals_date_joined: chr  "2011-10-05 20:35:19 UTC+0000" "2011-10-05 20:49:21 UTC+0000" "2011-10-18 17:31:26 UTC+0000" "2011-11-09 20:39:29 UTC+0000" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## professionals_prepped 
    ##  
    ## 'data.frame':    28152 obs. of  19 variables:
    ##  $ professionals_id            : chr  "00009a0f9bda43eba47104e9ac62aff5" "000196ef8db54b9a86ae70ad31745d04" "0008138be908438e8944b21f7f57f2c1" "000d4635e5da41e3bfd83677ee11dda4" ...
    ##  $ professionals_location      : chr  "New York, New York" "Chicago, Illinois" "Raipur, India" "Nashville, Tennessee" ...
    ##  $ professionals_industry      : chr  "Other" "Accounting" "Real Estate" "Information Technology and Services" ...
    ##  $ professionals_headline      : chr  "Digital Production & Content Consultant" "Director at PwC" "--" "Director Global Marketing and Sales Strategy DELL" ...
    ##  $ professionals_date_joined   : chr  "2016-03-14" "2018-05-15" "2018-11-05" "2016-04-27" ...
    ##  $ professionals_loc_div       : chr  "Mid-Atlantic" "East North Central" "International" "East South Central" ...
    ##  $ professionals_country       : chr  "United States" "United States" "India" "United States" ...
    ##  $ total_answers               : int  3 0 0 3 0 0 0 0 24 0 ...
    ##  $ avg_ans_word_count          : num  146.7 0 0 51.3 0 ...
    ##  $ avg_ans_num_sents           : num  12 0 0 2.33 0 ...
    ##  $ avg_ans_sent_length         : num  14.1 0 0 27 0 ...
    ##  $ tot_words_written           : int  440 0 0 154 0 0 0 0 1719 0 ...
    ##  $ professionals_acct_age      : int  1054 262 88 1010 478 253 171 1807 142 996 ...
    ##  $ email_notification_daily    : int  12 42 0 662 3 10 0 113 19 5 ...
    ##  $ email_notification_immediate: int  2 0 0 283 0 0 0 67 0 0 ...
    ##  $ email_notification_weekly   : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ tags_followed               : int  3 1 1 3 1 1 3 16 1 1 ...
    ##  $ total_hearts                : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ total_comments              : int  3 0 0 3 0 0 0 0 24 0 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## question_scores 
    ##  
    ## 'data.frame':    23928 obs. of  2 variables:
    ##  $ id   : chr  "38436aadef3d4b608ad089cf53ab0fe7" "edb8c179c5d64c9cb812a59a32045f55" "333464d7484b43e3866e86096bc4ddb9" "4b995e60b99d4ee18346e893e007cb8f" ...
    ##  $ score: int  5 4 6 6 6 1 1 5 6 5 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## questions 
    ##  
    ## 'data.frame':    23931 obs. of  5 variables:
    ##  $ questions_id        : chr  "332a511f1569444485cf7a7a556a5e54" "eb80205482e4424cad8f16bc25aa2d9c" "4ec31632938a40b98909416bdd0decff" "2f6a9a99d9b24e5baa50d40d0ba50a75" ...
    ##  $ questions_author_id : chr  "8f6f374ffd834d258ab69d376dd998f5" "acccbda28edd4362ab03fb8b6fd2d67b" "f2c179a563024ccc927399ce529094b5" "2c30ffba444e40eabb4583b55233a5a4" ...
    ##  $ questions_date_added: chr  "2016-04-26 11:14:26 UTC+0000" "2016-05-20 16:48:25 UTC+0000" "2017-02-08 19:13:38 UTC+0000" "2017-09-01 14:05:32 UTC+0000" ...
    ##  $ questions_title     : chr  "Teacher   career   question" "I want to become an army officer. What can I do to become an army officer?" "Will going abroad for your first job increase your chances for jobs back home?" "To become a specialist in business  management, will I have to network myself?" ...
    ##  $ questions_body      : chr  "What  is  a  maths  teacher?   what  is  a  maths  teacher  useful? #college #professor #lecture" "I am Priyanka from Bangalore . Now am in 10th std . When I go to college I should not get confused on what I wa"| __truncated__ "I'm planning on going abroad for my first job. It will be a teaching job and I don't have any serious career id"| __truncated__ "i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking " ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## questions_withTopics 
    ##  
    ## 'data.frame':    23931 obs. of  9 variables:
    ##  $ X                   : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ text_id             : chr  "text1" "text2" "text3" "text4" ...
    ##  $ questions_id        : chr  "332a511f1569444485cf7a7a556a5e54" "eb80205482e4424cad8f16bc25aa2d9c" "4ec31632938a40b98909416bdd0decff" "2f6a9a99d9b24e5baa50d40d0ba50a75" ...
    ##  $ questions_author_id : chr  "8f6f374ffd834d258ab69d376dd998f5" "acccbda28edd4362ab03fb8b6fd2d67b" "f2c179a563024ccc927399ce529094b5" "2c30ffba444e40eabb4583b55233a5a4" ...
    ##  $ questions_date_added: chr  "2016-04-26 11:14:26 UTC+0000" "2016-05-20 16:48:25 UTC+0000" "2017-02-08 19:13:38 UTC+0000" "2017-09-01 14:05:32 UTC+0000" ...
    ##  $ questions_title     : chr  "Teacher   career   question" "I want to become an army officer. What can I do to become an army officer?" "Will going abroad for your first job increase your chances for jobs back home?" "To become a specialist in business  management, will I have to network myself?" ...
    ##  $ questions_body      : chr  "What  is  a  maths  teacher?   what  is  a  maths  teacher  useful? #college #professor #lecture" "I am Priyanka from Bangalore . Now am in 10th std . When I go to college I should not get confused on what I wa"| __truncated__ "I'm planning on going abroad for my first job. It will be a teaching job and I don't have any serious career id"| __truncated__ "i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking " ...
    ##  $ text_cleaned        : chr  "whatisamathsteacher?whatisamathsteacheruseful? #college #professor #lecture" "i am priyanka from bangalore . now am in 10th std . when i go to college i should not get confused on what i wa"| __truncated__ "i'm planning on going abroad for my first job. it will be a teaching job and i don't have any serious career id"| __truncated__ "i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking" ...
    ##  $ topic_lda           : int  2 9 8 8 5 6 6 1 6 7 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## school_memberships 
    ##  
    ## 'data.frame':    5638 obs. of  2 variables:
    ##  $ school_memberships_school_id: int  197406 197398 199821 186239 182063 197893 197913 198515 197922 102979 ...
    ##  $ school_memberships_user_id  : chr  "23dce13ca6164a73aec7a3cd56a4884d" "23dce13ca6164a73aec7a3cd56a4884d" "23dce13ca6164a73aec7a3cd56a4884d" "9c5803ae43ca4cf6b27ea85871625116" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## students 
    ##  
    ## 'data.frame':    30971 obs. of  3 variables:
    ##  $ students_id         : chr  "12a89e96755a4dba83ff03e03043d9c0" "e37a5990fe354c60be5e87376b08d5e3" "12b402cceeda43dcb6e12ef9f2d221ea" "a0f431fc79794edcb104f68ce55ab897" ...
    ##  $ students_location   : chr  NA NA NA NA ...
    ##  $ students_date_joined: chr  "2011-12-16 14:19:24 UTC+0000" "2011-12-27 03:02:44 UTC+0000" "2012-01-01 05:00:00 UTC+0000" "2012-01-01 05:00:00 UTC+0000" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## students_prepped 
    ##  
    ## 'data.frame':    30971 obs. of  12 variables:
    ##  $ students_id         : chr  "0001a66883f74e8d91884fc6ea0d66a7" "0004592176864233990d949862baa2f3" "00069bb26ad64897b2793c81325a4440" "0008238db56e45b9a40a9ddd219fab2f" ...
    ##  $ students_location   : chr  "Henderson, Texas" "Boston, Massachusetts" "Philadelphia, Pennsylvania" "San Francisco, California" ...
    ##  $ students_date_joined: chr  "2018-08-21" "2016-03-09" "2016-05-25" "2015-03-17" ...
    ##  $ students_loc_div    : chr  "West South Central" "New England" "Mid-Atlantic" "Pacific" ...
    ##  $ students_country    : chr  "United States" "United States" "United States" "United States" ...
    ##  $ students_acct_age   : int  164 1059 982 1417 895 234 953 891 714 518 ...
    ##  $ tags_followed       : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ school_mem_status   : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ total_questions     : int  2 1 0 0 0 0 0 0 0 0 ...
    ##  $ tot_words_written   : int  47 45 0 0 0 0 0 0 0 0 ...
    ##  $ total_hearts        : int  4 3 0 0 0 0 0 0 0 0 ...
    ##  $ total_comments      : int  2 1 0 0 0 0 0 0 0 0 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## tag_questions 
    ##  
    ## 'data.frame':    76553 obs. of  2 variables:
    ##  $ tag_questions_tag_id     : int  28930 28930 28930 28930 28930 28930 28930 28930 28930 28930 ...
    ##  $ tag_questions_question_id: chr  "cb43ebee01364c68ac61d347a393ae39" "47f55e85ce944242a5a347ab85a8ffb4" "ccc30a033a0f4dfdb2eb987012f25792" "e30b274e48d741f7bf50eb5e7171a3c0" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## tag_users 
    ##  
    ## 'data.frame':    136663 obs. of  2 variables:
    ##  $ tag_users_tag_id : int  593 1642 638 11093 21539 1047 64 1139 55 54 ...
    ##  $ tag_users_user_id: chr  "c72ab38e073246e88da7e9a4ec7a4472" "8db519781ec24f2e8bdc67c2ac53f614" "042d2184ee3e4e548fc3589baaa69caf" "c660bd0dc1b34224be78a58aa5a84a63" ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## tags 
    ##  
    ## 'data.frame':    16269 obs. of  2 variables:
    ##  $ tags_tag_id  : int  27490 461 593 27292 18217 54 129 89 53 55 ...
    ##  $ tags_tag_name: chr  "college" "computer-science" "computer-software" "business" ...
    ## NULL
    ## _______________________________________________________________________________________

## 2d. Heads of each table

``` r
for (i in 1:length(filenames)) {
  cat(filenames[i], "\n", "\n")
  print(head(get(as.name(filenames[i]))))
  cat('_______________________________________________________________________________________', "\n")
}
```

    ## answer_scores 
    ##  
    ##                                 id score
    ## 1 7b2bb0fc0d384e298cffa6afde9cf6ab     1
    ## 2 7640a6e5d5224c8681cc58de860858f4     5
    ## 3 3ce32e236fa9435183b2180fb213375c     2
    ## 4 fa30fe4c016043e382c441a7ef743bfb     0
    ## 5 71229eb293314c8a9e545057ecc32c93     2
    ## 6 7d1a41e5ef48410fa7ff647a4bf87eed     1
    ## _______________________________________________________________________________________ 
    ## answers 
    ##  
    ##                         answers_id                answers_author_id
    ## 1 4e5f01128cae4f6d8fd697cec5dca60c 36ff3b3666df400f956f8335cf53e09e
    ## 2 ada720538c014e9b8a6dceed09385ee3 2aa47af241bf42a4b874c453f0381bd4
    ## 3 eaa66ef919bc408ab5296237440e323f cbd8f30613a849bf918aed5c010340be
    ## 4 1a6b3749d391486c9e371fbd1e605014 7e72a630c303442ba92ff00e8ea451df
    ## 5 5229c514000446d582050f89ebd4e184 17802d94699140b0a0d2995f30c034c6
    ## 6 5f62fadae80748c7907e3b0551bf4203 b03c3872daeb4a5cb1d8cd510942f0c4
    ##                answers_question_id           answers_date_added
    ## 1 332a511f1569444485cf7a7a556a5e54 2016-04-29 19:40:14 UTC+0000
    ## 2 eb80205482e4424cad8f16bc25aa2d9c 2018-05-01 14:19:08 UTC+0000
    ## 3 eb80205482e4424cad8f16bc25aa2d9c 2018-05-02 02:41:02 UTC+0000
    ## 4 4ec31632938a40b98909416bdd0decff 2017-05-10 19:00:47 UTC+0000
    ## 5 2f6a9a99d9b24e5baa50d40d0ba50a75 2017-10-13 22:07:33 UTC+0000
    ## 6 2f6a9a99d9b24e5baa50d40d0ba50a75 2017-10-12 16:01:44 UTC+0000
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   answers_body
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  <p>Hi!</p>\n<p>You are asking a very interesting question.  I am giving you two sites that will give you some of an explanation that may answer your question.</p>\n<p>http://mathforum.org/dr.math/faq/faq.why.math.html</p>\n<p>http://www.mathworksheetscenter.com/mathtips/mathissoimportant.html</p>\n<p>Let me know if this helps</p>
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     <p>Hi. I joined the Army after I attended college and received a Bachelor's Degree in Criminal Justice.  Commissioned officers enter the Military with a four year degree or receive officer training after joining and complete a tour. You can prepare yourself by taking Reserve Officer Training Corps (ROTC) while in high school or a university. You can also attend Officer Candidate School (OCS) after graduating from college or become commissioned by earning a professional degree. If you decide to earn a degree, think about what you would like to do while in the military.  The experience in the military was very rewarding. I wish you well and much success in your future. </p>
    ## 3 <p>Dear Priyanka,</p><p>Greetings! I have answered this question to Eshwari few days ago. I am going to reproduce that answer with bit of modifications as required for better clarity. </p><p><br></p><p>From your background, I could make out that you are from Bangalore and a student of 10th standard but your location is Rhode Island, USA. So I am not very clear as to which Army you wish to join ? Is it the US Army or the Indian Army? It is important to know that very few foreign nationals can join Indian Army (like Nepali citizens etc.). So you have to ascertain for yourself as to which citizenship you hold and accordingly you can join armed forces of the respective countries. Both are highly professional armies and respected a lot. I shall answer the modalities about the Indian Army, assuming that is the natural choice.</p><p><br></p><p>So, to answer your query, there are following options for you to become army officer:</p><ol><li> Do your B.Sc  and that will be good as you have wider choices including flying branches in air force and executive branches in Navy. Similarly BA/B.Com if you are not looking for flying or executive branches. </li><li>  Should you wish to be doctor in Army then you can appear for entrance Test for AFMC, Pune or Army Dental College after class 12th with PCMB. However, you can do the same by attending Medical colleges from civil institutes in India/abroad.  </li><li> You can also join Military Nursing Services after B.Sc or Diploma in Nursing but majority of them are trained within army organisations (after 12th only  with PCMB). </li><li> You can join after doing your graduation in Engineering (Civil, Mech, Electrical, Electronics or Computer Sciences) or Masters in Physics with Electronics or Computers for engineering branches.</li><li>You can also join in Education Corps by doing M.Sc/MA/M.Com with or without B.Ed or in Legal services by doing your Law Degree. </li></ol><p><br></p><p>After your basic education, application and selection test processes, one has to clear SSB (Services Selection Board) which is a very stringent 5 days test (compulsory for all including Women officers except medical professionals). It is one of the best methods of test I know to assess the suitability for military services (as officers), a proven method of testing of one's psyche, leadership qualities which takes  all the aspects of your personality into account and decide.  Although, success rate is pretty low but don't get disheartened and demotivated. Key to success in SSB is a sound mind with sound body, positive attitude and basic IQ.  If I could do with an average IQ and humble  educational backgrounds, why not you?  There were many friends (within my batch) of whom we thought that they will never make it to the SSB but they did qualify and now serving as  Major General. </p><p>Please refer the links given below and you can find scores of material to read about SSB on the net or through books.</p><p>All the Very Best! Jai Hind!</p>&lt;h1&gt;<br>&lt;/h1&gt;<p><br></p>
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  <p>I work for a global company who values highly international experience.  In fact, that is a key experience we look for in candidates.  Therefore, I'd say it would be wise to take advantage of the teaching opportunity - even if only for a year or 2.  You never know where it might lead and you will certainly have an edge on your return if you then look for employment in a global company.</p>
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               I agree with Denise. Every single job I've had since my first internship in college, I've found through connections. I have also been surprised that in some cases, connections that I least expected were crucial in helping me find new opportunities. For example, I am about to start a new role that in a lot of ways, is my dream job. A few months ago, I connected with someone that used to be on my team at a different company. We only worked on the same team for about 2 months, and 5 years later, ended up working at another tech company in Seattle. He ended up being the hiring manager for this new role, and after passing the other interviews, I got the job. \n\nI would say the most important thing when starting your career is to define what you want your brand to be, and what you want to be known for. This will help give you guidance on what activities and events to prioritize, books to read, etc. \n\nIt's also essential to be mindful of the impression you leave with others. While networking is essential to building your career, it's important that it's also backed up by a reputation you feel proud about. \n\nAs a student, I remember this feeling like an incredibly daunting task. It made it easier for me to find a group I could relate to. I joined ALPFA, an association for Latino Professionals that work across various business disciplines. I would recommend finding an organization that speaks to you, and begin practicing your networking skills there.
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Networking is a key component to progressing your career.  I've worked for several high tech organizations over many years and each job I was offered was because I knew someone who worked at the company who knew my skills and was able to advocate for me to get the job.  Without my professional and personal networks, it would have been much harder to get job offers and I may not have been as successful in my career.   \n\nDepending on the type of business/industry you would like to be in, you may have to start out as a team member or team contributor to grow your expertise in the business, possibly around a particular business function like operations, finance,  sales, etc.   As you become more knowledgeable and show your strengths in conducting your day to day work,  you will have a good chance to become a manager or leader of a team.   I do encourage you to take every networking opportunity that comes your way - join professional organizations, maybe your company or school offers networking activities you can join, and stay close to your social networks, you never know when a friend will help you find your next career move! 
    ## _______________________________________________________________________________________ 
    ## comments 
    ##  
    ##                        comments_id               comments_author_id
    ## 1 f30250d3c2ca489db1afa9b95d481e08 9fc88a7c3323466dbb35798264c7d497
    ## 2 ca9bfc4ba9464ea383a8b080301ad72c de2415064b9b445c8717425ed70fd99a
    ## 3 c354f6e33956499aa8b03798a60e9386 6ed20605002a42b0b8e3d6ac97c50c7f
    ## 4 73a6223948714c5da6231937157e4cb7 d02f6d9faac24997a7003a59e5f34bd3
    ## 5 55a89a9061d44dd19569c45f90a22779 e78f75c543e84e1c94da1801d8560f65
    ## 6 3661006cdb6f4595b193b8d9fbe21228 d02f6d9faac24997a7003a59e5f34bd3
    ##         comments_parent_content_id          comments_date_added
    ## 1 b476f9c6d9cd4c50a7bacdd90edd015a 2019-01-31 23:39:40 UTC+0000
    ## 2 ef4b6ae24d1f4c3b977731e8189c7fd7 2019-01-31 20:30:47 UTC+0000
    ## 3 ca7a9d7a95df471c816db82ee758f57d 2019-01-31 18:44:04 UTC+0000
    ## 4 c7a88aa76f5f49b0830bfeb46ba17e4d 2019-01-31 17:53:28 UTC+0000
    ## 5 c7a88aa76f5f49b0830bfeb46ba17e4d 2019-01-31 14:51:53 UTC+0000
    ## 6 30901132449849b2aa18f308306e89a2 2019-01-30 23:15:54 UTC+0000
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               comments_body
    ## 1                                                                                                                                                                                                                                                                                                                                                          First, you speak to recruiters. They are trained and knowledgable on all the requirements for each branch of service and can do the research for you on the specific job that you are looking at. \n\nAdditionally, birds of a feather do flock together. In high school, you can join groups like the Civil Air Patrol. The Civil Air Patrol is the auxiliary of the Air Force and many former and retired Air Force member within their ranks.
    ## 2                                                                                                                                                                                 Most large universities offer study abroad programs.  The study abroad programs are found on the schools website.  You may have to click into the Undergraduate or Graduate links.   I also recommend reaching out to the university counselors.  The have wealth of information and details that may not be on the website. \n\nMy son will be studying in France and Sweden next year through DePaul University.   The University of Southern California has a very strong international program in which most students participate.  It's a great opportunity to learn the culture of other countries while in school.
    ## 3 First, I want to put you at ease that the opposite can happen.  My dormmate that I was paired with my freshman year of college turned into one of my very best friends.  Second, we lived with another girl during our sophomore year; a good friend of ours that lived next to us the previous year.  To us, she was the annoying dormmate that you are mentioning and we already knew her!  Sometimes it takes living with someone to learn their annoying habits.  We could have swapped if someone else agreed to swap with us.  Instead we tried to talk to her about it.  When it did not get better, my other dormmate and I strategized how we could avoid the annoying habits.  For instance, we agreed that the habits were most annoying when we were trying to study so we studied elsewhere.
    ## 4                                                                                                                                                                                                                                                                                                                                Your question submission was great! I just wanted to point out that if you break your original question into separate and slightly more specific points (like "In addition to the LSAT what is the Law School acceptance process like..." you might also get some great Advice from our professionals. General questions are always welcome too, just make sure to leave some detail (like you did) of why you are interested etc. Welcome to the CareerVillage community!
    ## 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Thank you. I'm new to this site. I'm sorry if what I put out there is spam. I will for sure read through those forums.
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   My pleasure! I'm so glad I was helpful!
    ## _______________________________________________________________________________________ 
    ## emails 
    ##  
    ##   emails_id              emails_recipient_id             emails_date_sent
    ## 1   2337714 0c673e046d824ec0ad0ebe012a0673e4 2018-12-07 01:05:40 UTC+0000
    ## 2   2336077 0c673e046d824ec0ad0ebe012a0673e4 2018-12-06 01:14:15 UTC+0000
    ## 3   2314660 0c673e046d824ec0ad0ebe012a0673e4 2018-11-17 00:38:27 UTC+0000
    ## 4   2312639 0c673e046d824ec0ad0ebe012a0673e4 2018-11-16 00:32:19 UTC+0000
    ## 5   2299700 0c673e046d824ec0ad0ebe012a0673e4 2018-11-08 00:16:40 UTC+0000
    ## 6   2288533 0c673e046d824ec0ad0ebe012a0673e4 2018-11-02 23:02:12 UTC+0000
    ##     emails_frequency_level
    ## 1 email_notification_daily
    ## 2 email_notification_daily
    ## 3 email_notification_daily
    ## 4 email_notification_daily
    ## 5 email_notification_daily
    ## 6 email_notification_daily
    ## _______________________________________________________________________________________ 
    ## group_memberships 
    ##  
    ##         group_memberships_group_id        group_memberships_user_id
    ## 1 eabbdf4029734c848a9da20779637d03 9a5aead62c344207b2624dba90985dc5
    ## 2 eabbdf4029734c848a9da20779637d03 ea7122da1c7b4244a2184a4f9f944053
    ## 3 eabbdf4029734c848a9da20779637d03 cba603f34acb4a40b3ccb53fe6681b5d
    ## 4 eabbdf4029734c848a9da20779637d03 fa9a126e63714641ae0145557a390cab
    ## 5 eabbdf4029734c848a9da20779637d03 299da113c5d1420ab525106c242c9429
    ## 6 7080bf8dcf78463bb03e6863887fd715 836a747118d6436caf56ff3a3c47289a
    ## _______________________________________________________________________________________ 
    ## groups 
    ##  
    ##                          groups_id groups_group_type
    ## 1 eabbdf4029734c848a9da20779637d03     youth program
    ## 2 7080bf8dcf78463bb03e6863887fd715     youth program
    ## 3 bc6fc50a2b444efc8ec47111b290ffb8     youth program
    ## 4 37f002e8d5e442ca8e36e972eaa55882     youth program
    ## 5 52419ff84d4b47bebd0b0a6c1263c296     youth program
    ## 6 559dbc7bd1f64c268ff149c4d5d63500     youth program
    ## _______________________________________________________________________________________ 
    ## matches 
    ##  
    ##   matches_email_id              matches_question_id
    ## 1          1721939 332a511f1569444485cf7a7a556a5e54
    ## 2          1665388 332a511f1569444485cf7a7a556a5e54
    ## 3          1636634 332a511f1569444485cf7a7a556a5e54
    ## 4          1635498 332a511f1569444485cf7a7a556a5e54
    ## 5          1620298 332a511f1569444485cf7a7a556a5e54
    ## 6          1618336 332a511f1569444485cf7a7a556a5e54
    ## _______________________________________________________________________________________ 
    ## prof_geo 
    ##  
    ##   X professionals.professionals_location       lon      lat
    ## 1 1                   New York, New York -77.88562 42.87107
    ## 2 2                Boston, Massachusetts -71.05888 42.36008
    ## 3 3                 Milwaukee, Wisconsin -87.90647 43.03890
    ## 4 4                   New York, New York -74.00597 40.71278
    ## 5 5                  Wilmington, Vermont -72.87145 42.86839
    ## 6 6                   New York, New York -77.88562 42.87107
    ## _______________________________________________________________________________________ 
    ## professionals 
    ##  
    ##                   professionals_id professionals_location
    ## 1 9ced4ce7519049c0944147afb75a8ce3                   <NA>
    ## 2 f718dcf6d2ec4cb0a52a9db59d7f9e67                   <NA>
    ## 3 0c673e046d824ec0ad0ebe012a0673e4     New York, New York
    ## 4 977428d851b24183b223be0eb8619a8c  Boston, Massachusetts
    ## 5 e2d57e5041a44f489288397c9904c2b2                   <NA>
    ## 6 c9bfa93898594cbbace436deca644c64                   <NA>
    ##   professionals_industry professionals_headline    professionals_date_joined
    ## 1                   <NA>                   <NA> 2011-10-05 20:35:19 UTC+0000
    ## 2                   <NA>                   <NA> 2011-10-05 20:49:21 UTC+0000
    ## 3                   <NA>                   <NA> 2011-10-18 17:31:26 UTC+0000
    ## 4                   <NA>                   <NA> 2011-11-09 20:39:29 UTC+0000
    ## 5                   <NA>                   <NA> 2011-12-10 22:14:44 UTC+0000
    ## 6                   <NA>                   <NA> 2011-12-12 14:25:46 UTC+0000
    ## _______________________________________________________________________________________ 
    ## professionals_prepped 
    ##  
    ##                   professionals_id professionals_location
    ## 1 00009a0f9bda43eba47104e9ac62aff5     New York, New York
    ## 2 000196ef8db54b9a86ae70ad31745d04      Chicago, Illinois
    ## 3 0008138be908438e8944b21f7f57f2c1          Raipur, India
    ## 4 000d4635e5da41e3bfd83677ee11dda4   Nashville, Tennessee
    ## 5 000e2b5714444d79a672bf927905135c      Detroit, Michigan
    ## 6 0018873fbf7742aba1bf13fff12cbfa4       Portland, Oregon
    ##                professionals_industry
    ## 1                               Other
    ## 2                          Accounting
    ## 3                         Real Estate
    ## 4 Information Technology and Services
    ## 5                             Finance
    ## 6                             Finance
    ##                                 professionals_headline
    ## 1              Digital Production & Content Consultant
    ## 2                                      Director at PwC
    ## 3                                                   --
    ## 4    Director Global Marketing and Sales Strategy DELL
    ## 5   National Account Representative at SourceHOV | Tax
    ## 6 Enterprise Architect specializing in digital banking
    ##   professionals_date_joined professionals_loc_div professionals_country
    ## 1                2016-03-14          Mid-Atlantic         United States
    ## 2                2018-05-15    East North Central         United States
    ## 3                2018-11-05         International                 India
    ## 4                2016-04-27    East South Central         United States
    ## 5                2017-10-11    East North Central         United States
    ## 6                2018-05-24               Pacific         United States
    ##   total_answers avg_ans_word_count avg_ans_num_sents avg_ans_sent_length
    ## 1             3          146.66667         12.000000            14.12963
    ## 2             0            0.00000          0.000000             0.00000
    ## 3             0            0.00000          0.000000             0.00000
    ## 4             3           51.33333          2.333333            27.00000
    ## 5             0            0.00000          0.000000             0.00000
    ## 6             0            0.00000          0.000000             0.00000
    ##   tot_words_written professionals_acct_age email_notification_daily
    ## 1               440                   1054                       12
    ## 2                 0                    262                       42
    ## 3                 0                     88                        0
    ## 4               154                   1010                      662
    ## 5                 0                    478                        3
    ## 6                 0                    253                       10
    ##   email_notification_immediate email_notification_weekly tags_followed
    ## 1                            2                         0             3
    ## 2                            0                         0             1
    ## 3                            0                         0             1
    ## 4                          283                         0             3
    ## 5                            0                         0             1
    ## 6                            0                         0             1
    ##   total_hearts total_comments
    ## 1            0              3
    ## 2            0              0
    ## 3            0              0
    ## 4            0              3
    ## 5            0              0
    ## 6            0              0
    ## _______________________________________________________________________________________ 
    ## question_scores 
    ##  
    ##                                 id score
    ## 1 38436aadef3d4b608ad089cf53ab0fe7     5
    ## 2 edb8c179c5d64c9cb812a59a32045f55     4
    ## 3 333464d7484b43e3866e86096bc4ddb9     6
    ## 4 4b995e60b99d4ee18346e893e007cb8f     6
    ## 5 f6b9ca94aed04ba28256492708e74f60     6
    ## 6 216abb4056a64b198bdc6544830c822a     1
    ## _______________________________________________________________________________________ 
    ## questions 
    ##  
    ##                       questions_id              questions_author_id
    ## 1 332a511f1569444485cf7a7a556a5e54 8f6f374ffd834d258ab69d376dd998f5
    ## 2 eb80205482e4424cad8f16bc25aa2d9c acccbda28edd4362ab03fb8b6fd2d67b
    ## 3 4ec31632938a40b98909416bdd0decff f2c179a563024ccc927399ce529094b5
    ## 4 2f6a9a99d9b24e5baa50d40d0ba50a75 2c30ffba444e40eabb4583b55233a5a4
    ## 5 5af8880460c141dbb02971a1a8369529 aa9eb1a2ab184ebbb00dc01ab663428a
    ## 6 7c336403258f4da3a2e0955742c76462 d1e4587c0e784c62bc27eb8d16a07f38
    ##           questions_date_added
    ## 1 2016-04-26 11:14:26 UTC+0000
    ## 2 2016-05-20 16:48:25 UTC+0000
    ## 3 2017-02-08 19:13:38 UTC+0000
    ## 4 2017-09-01 14:05:32 UTC+0000
    ## 5 2017-09-01 02:36:54 UTC+0000
    ## 6 2017-03-01 04:27:08 UTC+0000
    ##                                                                               questions_title
    ## 1                                                                 Teacher   career   question
    ## 2                  I want to become an army officer. What can I do to become an army officer?
    ## 3              Will going abroad for your first job increase your chances for jobs back home?
    ## 4              To become a specialist in business  management, will I have to network myself?
    ## 5 Are there any scholarships out there for students that are first generation and live in GA?
    ## 6                                       How many years of coege do you need to be an engineer
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     questions_body
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                 What  is  a  maths  teacher?   what  is  a  maths  teacher  useful? #college #professor #lecture
    ## 2                                                                                                                                                                                                                                                                                                  I am Priyanka from Bangalore . Now am in 10th std . When I go to college I should not get confused on what I want to take to become army officer. So I am asking this question  #military #army
    ## 3 I'm planning on going abroad for my first job. It will be a teaching job and I don't have any serious career ideas. I don't know what job I would be working if I stay home instead so I'm assuming staying or leaving won't makeba huge difference in what I care about, unless I find something before my first job. I can think of ways that going abroad can be seen as good and bad. I do not know which side respectable employers willl side with. #working-abroad #employment- #overseas
    ## 4                                                                                                                                                                                                                                                                                                                                                                             i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking 
    ## 5                                                                                                                                                                                                                                                                                                     I'm trying to find scholarships for first year students but they all seem to be for other states besides GA. Any help??\n\n#college\n#scholarships \n#highschoolsenior \n#firstgeneration \n
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                 To be an engineer #united-states
    ## _______________________________________________________________________________________ 
    ## questions_withTopics 
    ##  
    ##   X text_id                     questions_id              questions_author_id
    ## 1 1   text1 332a511f1569444485cf7a7a556a5e54 8f6f374ffd834d258ab69d376dd998f5
    ## 2 2   text2 eb80205482e4424cad8f16bc25aa2d9c acccbda28edd4362ab03fb8b6fd2d67b
    ## 3 3   text3 4ec31632938a40b98909416bdd0decff f2c179a563024ccc927399ce529094b5
    ## 4 4   text4 2f6a9a99d9b24e5baa50d40d0ba50a75 2c30ffba444e40eabb4583b55233a5a4
    ## 5 5   text5 5af8880460c141dbb02971a1a8369529 aa9eb1a2ab184ebbb00dc01ab663428a
    ## 6 6   text6 7c336403258f4da3a2e0955742c76462 d1e4587c0e784c62bc27eb8d16a07f38
    ##           questions_date_added
    ## 1 2016-04-26 11:14:26 UTC+0000
    ## 2 2016-05-20 16:48:25 UTC+0000
    ## 3 2017-02-08 19:13:38 UTC+0000
    ## 4 2017-09-01 14:05:32 UTC+0000
    ## 5 2017-09-01 02:36:54 UTC+0000
    ## 6 2017-03-01 04:27:08 UTC+0000
    ##                                                                               questions_title
    ## 1                                                                 Teacher   career   question
    ## 2                  I want to become an army officer. What can I do to become an army officer?
    ## 3              Will going abroad for your first job increase your chances for jobs back home?
    ## 4              To become a specialist in business  management, will I have to network myself?
    ## 5 Are there any scholarships out there for students that are first generation and live in GA?
    ## 6                                       How many years of coege do you need to be an engineer
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     questions_body
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                 What  is  a  maths  teacher?   what  is  a  maths  teacher  useful? #college #professor #lecture
    ## 2                                                                                                                                                                                                                                                                                                  I am Priyanka from Bangalore . Now am in 10th std . When I go to college I should not get confused on what I want to take to become army officer. So I am asking this question  #military #army
    ## 3 I'm planning on going abroad for my first job. It will be a teaching job and I don't have any serious career ideas. I don't know what job I would be working if I stay home instead so I'm assuming staying or leaving won't makeba huge difference in what I care about, unless I find something before my first job. I can think of ways that going abroad can be seen as good and bad. I do not know which side respectable employers willl side with. #working-abroad #employment- #overseas
    ## 4                                                                                                                                                                                                                                                                                                                                                                             i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking 
    ## 5                                                                                                                                                                                                                                                                                                     I'm trying to find scholarships for first year students but they all seem to be for other states besides GA. Any help??\n\n#college\n#scholarships \n#highschoolsenior \n#firstgeneration \n
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                 To be an engineer #united-states
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       text_cleaned
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                      whatisamathsteacher?whatisamathsteacheruseful? #college #professor #lecture
    ## 2                                                                                                                                                                                                                                                                                                    i am priyanka from bangalore . now am in 10th std . when i go to college i should not get confused on what i want to take to become army officer. so i am asking this question#military #army
    ## 3 i'm planning on going abroad for my first job. it will be a teaching job and i don't have any serious career ideas. i don't know what job i would be working if i stay home instead so i'm assuming staying or leaving won't makeba huge difference in what i care about, unless i find something before my first job. i can think of ways that going abroad can be seen as good and bad. i do not know which side respectable employers willl side with. #working-abroad #employment- #overseas
    ## 4                                                                                                                                                                                                                                                                                                                                                                              i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking
    ## 5                                                                                                                                                                                                                                                                                                        i'm trying to find scholarships for first year students but they all seem to be for other states besides ga. any help??\n\n#college\n#scholarships \n#highschoolsenior \n#firstgeneration
    ## 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                 to be an engineer #united-states
    ##   topic_lda
    ## 1         2
    ## 2         9
    ## 3         8
    ## 4         8
    ## 5         5
    ## 6         6
    ## _______________________________________________________________________________________ 
    ## school_memberships 
    ##  
    ##   school_memberships_school_id       school_memberships_user_id
    ## 1                       197406 23dce13ca6164a73aec7a3cd56a4884d
    ## 2                       197398 23dce13ca6164a73aec7a3cd56a4884d
    ## 3                       199821 23dce13ca6164a73aec7a3cd56a4884d
    ## 4                       186239 9c5803ae43ca4cf6b27ea85871625116
    ## 5                       182063 9c5803ae43ca4cf6b27ea85871625116
    ## 6                       197893 9c5803ae43ca4cf6b27ea85871625116
    ## _______________________________________________________________________________________ 
    ## students 
    ##  
    ##                        students_id students_location
    ## 1 12a89e96755a4dba83ff03e03043d9c0              <NA>
    ## 2 e37a5990fe354c60be5e87376b08d5e3              <NA>
    ## 3 12b402cceeda43dcb6e12ef9f2d221ea              <NA>
    ## 4 a0f431fc79794edcb104f68ce55ab897              <NA>
    ## 5 23aea4702d804bd88d1e9fb28074a1b4              <NA>
    ## 6 18a8f9363cd24a37b690e1b205146b14              <NA>
    ##           students_date_joined
    ## 1 2011-12-16 14:19:24 UTC+0000
    ## 2 2011-12-27 03:02:44 UTC+0000
    ## 3 2012-01-01 05:00:00 UTC+0000
    ## 4 2012-01-01 05:00:00 UTC+0000
    ## 5 2012-01-01 05:00:00 UTC+0000
    ## 6 2012-01-01 05:00:00 UTC+0000
    ## _______________________________________________________________________________________ 
    ## students_prepped 
    ##  
    ##                        students_id          students_location
    ## 1 0001a66883f74e8d91884fc6ea0d66a7           Henderson, Texas
    ## 2 0004592176864233990d949862baa2f3      Boston, Massachusetts
    ## 3 00069bb26ad64897b2793c81325a4440 Philadelphia, Pennsylvania
    ## 4 0008238db56e45b9a40a9ddd219fab2f  San Francisco, California
    ## 5 000b6972b8514f1b91a2c06e0cd7bccb           Atlanta, Georgia
    ## 6 000bddd0c3c34a0cb324aa294a320ab1                 Rudd, Iowa
    ##   students_date_joined   students_loc_div students_country students_acct_age
    ## 1           2018-08-21 West South Central    United States               164
    ## 2           2016-03-09        New England    United States              1059
    ## 3           2016-05-25       Mid-Atlantic    United States               982
    ## 4           2015-03-17            Pacific    United States              1417
    ## 5           2016-08-20     South Atlantic    United States               895
    ## 6           2018-06-12 West North Central    United States               234
    ##   tags_followed school_mem_status total_questions tot_words_written
    ## 1             0                 0               2                47
    ## 2             0                 0               1                45
    ## 3             0                 0               0                 0
    ## 4             0                 0               0                 0
    ## 5             0                 0               0                 0
    ## 6             0                 0               0                 0
    ##   total_hearts total_comments
    ## 1            4              2
    ## 2            3              1
    ## 3            0              0
    ## 4            0              0
    ## 5            0              0
    ## 6            0              0
    ## _______________________________________________________________________________________ 
    ## tag_questions 
    ##  
    ##   tag_questions_tag_id        tag_questions_question_id
    ## 1                28930 cb43ebee01364c68ac61d347a393ae39
    ## 2                28930 47f55e85ce944242a5a347ab85a8ffb4
    ## 3                28930 ccc30a033a0f4dfdb2eb987012f25792
    ## 4                28930 e30b274e48d741f7bf50eb5e7171a3c0
    ## 5                28930 3d22742052df4989b311b4195cbb0f1a
    ## 6                28930 c79baebeb6d44726b6f70a2414fb69bc
    ## _______________________________________________________________________________________ 
    ## tag_users 
    ##  
    ##   tag_users_tag_id                tag_users_user_id
    ## 1              593 c72ab38e073246e88da7e9a4ec7a4472
    ## 2             1642 8db519781ec24f2e8bdc67c2ac53f614
    ## 3              638 042d2184ee3e4e548fc3589baaa69caf
    ## 4            11093 c660bd0dc1b34224be78a58aa5a84a63
    ## 5            21539 8ce1dca4e94240239e4385ed22ef43ce
    ## 6             1047 3330f8a7835346a2a91f9393ae21efee
    ## _______________________________________________________________________________________ 
    ## tags 
    ##  
    ##   tags_tag_id     tags_tag_name
    ## 1       27490           college
    ## 2         461  computer-science
    ## 3         593 computer-software
    ## 4       27292          business
    ## 5       18217            doctor
    ## 6          54       engineering
    ## _______________________________________________________________________________________

## 3. Missing Values, Transformations, Feature Engineering, and Aggregation

### professionals

The scripts sourced below complete the following actions: <br> \* Create
variable professionals_loc_div by binning professionals location into
U.S. Geographic Division <br> \* Create variable professionals_country
by binning professionals location into country <br> \* Transform
professionals_date_joined into datetime, and remove hh:mm:ss <br> \*
Compute account age by subtracting from 2019-02-01, the day after data
was collected  
\* Impute “Not Specified” for NA fields  
\* Standardize industry names  
\* Compute total answers submitted  
\* Compute average word count, average sentence count, and average
sentence length for submitted answers, and total words written  
\* Compute number of emails of each type received (immediate, daily, and
weekly)  
\* Compute number of tags followed  
\* Compute number of hearts received  
\* Compute total number of comments received

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/pros_loc_div.R")
```

    ## 'data.frame':    28152 obs. of  7 variables:
    ##  $ professionals_id         : chr  "9ced4ce7519049c0944147afb75a8ce3" "f718dcf6d2ec4cb0a52a9db59d7f9e67" "0c673e046d824ec0ad0ebe012a0673e4" "977428d851b24183b223be0eb8619a8c" ...
    ##  $ professionals_location   : chr  "Not Specified" "Not Specified" "New York, New York" "Boston, Massachusetts" ...
    ##  $ professionals_industry   : chr  "Not Specified" "Not Specified" "Not Specified" "Not Specified" ...
    ##  $ professionals_headline   : chr  "Not Specified" "Not Specified" "Not Specified" "Not Specified" ...
    ##  $ professionals_date_joined: Date, format: "2011-10-05" "2011-10-05" ...
    ##  $ professionals_loc_div    : Factor w/ 11 levels "East North Central",..: 7 7 4 6 7 7 7 7 7 7 ...
    ##  $ professionals_country    : Factor w/ 150 levels "Afghanistan",..: 94 94 143 143 94 94 94 94 94 94 ...
    ## NULL

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/answers_by_industry.R")
```

    ## Warning: NA is replaced by empty string

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/pros__age_headline_emails.R")
```

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## profession could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## specialist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## softwar could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## product could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## project could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## program could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## intern could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## graduat could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## technolog could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## school could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## colleg could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## research could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## opportun could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## global could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## execut could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## coordin could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## health could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## support could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## career could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## advisor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : assur
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## scienc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## system could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : state
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : data
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : coach
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## teacher could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## corpor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## social could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## communic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## communiti could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : medic
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : nurs
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## mechan could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## experienc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## counselor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## experi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## leader could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## administr could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : digit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## writer could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : human
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : media
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## strategi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## center could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : tech
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : group
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## symantec could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## general could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## supervisor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## produc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## resourc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## recruit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : googl
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## presid could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## artist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## attorney could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## network could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## partner could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## clinic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## master could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## compani could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## comput could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## linkedin could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : secur
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## freelanc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## financ could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## analyt could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## public could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## architect could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## talent could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## biomed could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## industri could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : zynga
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## certifi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## client could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : owner
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : team
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## enterpris could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : care
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## process could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : posit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## expert could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## editor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## scientist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : relat
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## princip could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : espn
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : advoc
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : risk
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## institut could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## hospit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : full-
    ## tim could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## pharmacist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## regist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : work
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : vice
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## creativ could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## environment could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## qualiti could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## professor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : train
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## technician could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## instructor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## nation could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## advisori could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : job
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## strateg could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : plan
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## attend could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## depart could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## graphic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## physic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## pricewaterhousecoop could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : help
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : mae
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## volunt could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## trainer could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : fanni
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## strategist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## entrepreneur could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## therapist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## repres could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## california could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : anim
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## candid could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## academ could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## founder could not be fit on page. It will not be plotted.

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on 'æˆ
    ## ´' in 'mbcsToSbcs': dot substituted for <e6>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on 'æˆ
    ## ´' in 'mbcsToSbcs': dot substituted for <88>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on 'æˆ
    ## ´' in 'mbcsToSbcs': dot substituted for <b4>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'æˆ´' in 'mbcsToSbcs': dot substituted for <e6>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'æˆ´' in 'mbcsToSbcs': dot substituted for <88>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'æˆ´' in 'mbcsToSbcs': dot substituted for <b4>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : font metrics unknown for Unicode character U+6234

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'å°”' in 'mbcsToSbcs': dot substituted for <e5>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'å°”' in 'mbcsToSbcs': dot substituted for <b0>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'å°”' in 'mbcsToSbcs': dot substituted for <94>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'å°”' in 'mbcsToSbcs': dot substituted for <e5>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'å°”' in 'mbcsToSbcs': dot substituted for <b0>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : conversion failure on 'å°”' in 'mbcsToSbcs': dot substituted for <94>

    ## Warning in text.default(x1, y1, word[i], cex = (1 + adjust) * size[i], offset =
    ## 0, : font metrics unknown for Unicode character U+5c14

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## content could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : innov
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : citi
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## inform could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : game
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## special could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## acquisit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : high
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## analysi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : brand
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## region could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : mba
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## invest could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## counti could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## doctor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## verizon could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : web
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## photograph could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## higher could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : event
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## leadership could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : life
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : legal
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## retail could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## psycholog could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## america could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## employ could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : engag
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : year
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## internship could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## district could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## success could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : peopl
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## healthcar could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## famili could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : chief
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## instruct could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : us
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : bank
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## applic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## perform could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## independ could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## airbnb could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## licens could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## forens could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## control could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : ltd
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## electr could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : aig
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : organ
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : mobil
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : area
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## worker could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : unit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## recent could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : emea
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : real
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## member could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## channel could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## complianc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : cloud
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## bachelor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : san
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : teach
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## intellig could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : actor
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## author could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : studi
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## suppli could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## employe could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## passion could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : sport
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : emc
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : estat
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## pharmaci could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : vp
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## biolog could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## contract could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : major
    ## could not be fit on page. It will not be plotted.

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <e7>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <bb>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <8f>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <e7>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <90>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'ç»ç†' in 'mbcsToSbcs': dot substituted for <86>

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## <U+7ECF><U+7406> could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## physician could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : co-
    ## found could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : ms
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : york
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## psychologist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## florida could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : polic
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : chang
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## english could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## illustr could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : video
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## integr could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## affair could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## fashion could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## privat could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## connect could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## current could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## chemic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : north
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## flight could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : aspir
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## practition could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## enthusiast could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## entertain could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## washington could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## respons could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : chef
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## aerospac could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## safeti could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## medicin could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## govern could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : lab
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## former could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : sap
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## canada could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## academi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : onlin
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## barclaycard could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## american could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## interior could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : india
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## admiss could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## journalist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## laboratori could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : rn
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : board
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pilot
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## transform could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## commerci could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## planner could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : well
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## improv could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## fellow could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : insur
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## microsoft could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## deliveri could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## mental could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : level
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## georgia could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : capit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : insid
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## programm could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## construct could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : degre
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## practic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## divers could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : world
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## dentist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## dental could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## athlet could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : llp
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : chain
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : tutor
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : hba
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## manufactur could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : op
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## studio could not be fit on page. It will not be plotted.

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <e9>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <94>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <80>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <e5>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <94>

    ## Warning in graphics::strwidth(word[i], cex = size[i]): conversion failure on
    ## 'é”€å”®' in 'mbcsToSbcs': dot substituted for <ae>

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## <U+9500><U+552E> could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : emerg
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## foundat could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : write
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## speaker could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## technologist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## consum could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## relationship could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## therapi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## mentor could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## investig could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : appl
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : food
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : skill
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## pediatr could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## wireless could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : 2017
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## adjunct could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## houston could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : user
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : aid
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## behavior could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : south
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : home
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## energi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## junior could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pacif
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## children could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : price
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : trust
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## undergradu could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : agent
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : hous
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## logist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : qa
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## organiz could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## biologist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : make
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## advanc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : audio
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## merchandis could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : aviat
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## chicago could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## person could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : excel
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## visual could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : phd
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : armi
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pvt
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## electron could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## partnership could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pro
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## compos could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## report could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## summer could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : youth
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : dalla
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## propos could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## veteran could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## languag could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : corp
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : feder
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## musician could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : enabl
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## michigan could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : focus
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## search could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## southern could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## architectur could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : build
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : 2018
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## boston could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : cisco
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## impact could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : west
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : right
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : film
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : fit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## justic could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## growth could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : asset
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : entri
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## implement could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## materi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## credit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## austin could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## polici could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : angel
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pimco
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : pursu
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : resid
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : audit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## photographi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : bay
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## nonprofit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## structur could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## provid could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : chez
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## illinoi could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : marin
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## regulatori could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : advis
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : limit
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## econom could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## central could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## facilit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : devic
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## portfolio could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## crimin could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## barclay could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : live
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : grad
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## travel could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## maryland could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : first
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : sourc
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## insight could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : sound
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : u.
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : case
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : model
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : cpa
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## sustain could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## outreach could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## charter could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : usa
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : start
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : john
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : cvs
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : los
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## generalist could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## mainten could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : fund
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## alumni could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : dynam
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## aircraft could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## allianc could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## transit could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## deploy could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, : can
    ## could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## achiev could not be fit on page. It will not be plotted.

    ## Warning in wordcloud(x, min_size, max_size, min_count, max_words, color, :
    ## blogger could not be fit on page. It will not be plotted.

    ## $xlog
    ## [1] FALSE
    ## 
    ## $ylog
    ## [1] FALSE
    ## 
    ## $adj
    ## [1] 0.5
    ## 
    ## $ann
    ## [1] TRUE
    ## 
    ## $ask
    ## [1] FALSE
    ## 
    ## $bg
    ## [1] "transparent"
    ## 
    ## $bty
    ## [1] "o"
    ## 
    ## $cex
    ## [1] 1
    ## 
    ## $cex.axis
    ## [1] 1
    ## 
    ## $cex.lab
    ## [1] 1
    ## 
    ## $cex.main
    ## [1] 1.2
    ## 
    ## $cex.sub
    ## [1] 1
    ## 
    ## $col
    ## [1] "black"
    ## 
    ## $col.axis
    ## [1] "black"
    ## 
    ## $col.lab
    ## [1] "black"
    ## 
    ## $col.main
    ## [1] "black"
    ## 
    ## $col.sub
    ## [1] "black"
    ## 
    ## $crt
    ## [1] 0
    ## 
    ## $err
    ## [1] 0
    ## 
    ## $family
    ## [1] ""
    ## 
    ## $fg
    ## [1] "black"
    ## 
    ## $fig
    ## [1] 0 1 0 1
    ## 
    ## $fin
    ## [1] 7 7
    ## 
    ## $font
    ## [1] 1
    ## 
    ## $font.axis
    ## [1] 1
    ## 
    ## $font.lab
    ## [1] 1
    ## 
    ## $font.main
    ## [1] 2
    ## 
    ## $font.sub
    ## [1] 1
    ## 
    ## $lab
    ## [1] 5 5 7
    ## 
    ## $las
    ## [1] 0
    ## 
    ## $lend
    ## [1] "round"
    ## 
    ## $lheight
    ## [1] 1
    ## 
    ## $ljoin
    ## [1] "round"
    ## 
    ## $lmitre
    ## [1] 10
    ## 
    ## $lty
    ## [1] "solid"
    ## 
    ## $lwd
    ## [1] 1
    ## 
    ## $mai
    ## [1] 0 0 0 0
    ## 
    ## $mar
    ## [1] 5.1 4.1 4.1 2.1
    ## 
    ## $mex
    ## [1] 1
    ## 
    ## $mfcol
    ## [1] 1 1
    ## 
    ## $mfg
    ## [1] 1 1 1 1
    ## 
    ## $mfrow
    ## [1] 1 1
    ## 
    ## $mgp
    ## [1] 3 1 0
    ## 
    ## $mkh
    ## [1] 0.001
    ## 
    ## $new
    ## [1] TRUE
    ## 
    ## $oma
    ## [1] 0 0 0 0
    ## 
    ## $omd
    ## [1] 0 1 0 1
    ## 
    ## $omi
    ## [1] 0 0 0 0
    ## 
    ## $pch
    ## [1] 1
    ## 
    ## $pin
    ## [1] 5.76 5.16
    ## 
    ## $plt
    ## [1] 0.08857143 0.91142857 0.13142857 0.86857143
    ## 
    ## $ps
    ## [1] 12
    ## 
    ## $pty
    ## [1] "m"
    ## 
    ## $smo
    ## [1] 1
    ## 
    ## $srt
    ## [1] 0
    ## 
    ## $tck
    ## [1] NA
    ## 
    ## $tcl
    ## [1] -0.5
    ## 
    ## $usr
    ## [1] -0.04  1.04 -0.04  1.04
    ## 
    ## $xaxp
    ## [1] 0 1 5
    ## 
    ## $xaxs
    ## [1] "r"
    ## 
    ## $xaxt
    ## [1] "s"
    ## 
    ## $xpd
    ## [1] FALSE
    ## 
    ## $yaxp
    ## [1] 0 1 5
    ## 
    ## $yaxs
    ## [1] "r"
    ## 
    ## $yaxt
    ## [1] "s"
    ## 
    ## $ylbias
    ## [1] 0.2

### students

The scripts sourced below complete the following actions: <br> \* Create
variable students_loc_div by binning student location into U.S.
Geographic Division <br> \* Create variable students_country by binning
student location into country <br> \* Transform students_date_joined
into datetime, and remove hh:mm:ss <br> \* Compute account age by
subtracting from 2019-02-01, the day after data was collected \* Imputed
“Not Specified” for NA fields \* Compute total questions submitted \*
Compute total words written \* Compute school membership status (0/1 for
N/Y, and 2 for more than 1 school) \* Compute number of tags followed \*
Compute number of hearts received \* Compute total number of comments
received

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/stud_loc_div.R")
```

    ## 'data.frame':    30971 obs. of  5 variables:
    ##  $ students_id         : chr  "12a89e96755a4dba83ff03e03043d9c0" "e37a5990fe354c60be5e87376b08d5e3" "12b402cceeda43dcb6e12ef9f2d221ea" "a0f431fc79794edcb104f68ce55ab897" ...
    ##  $ students_location   : chr  "Not Specified" "Not Specified" "Not Specified" "Not Specified" ...
    ##  $ students_date_joined: Date, format: "2011-12-16" "2011-12-27" ...
    ##  $ students_loc_div    : Factor w/ 11 levels "East North Central",..: 7 7 7 7 7 7 7 7 7 7 ...
    ##  $ students_country    : Factor w/ 134 levels "Afghanistan",..: 85 85 85 85 85 85 85 85 85 85 ...
    ## NULL

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/studs__age_tags_school.R")
```

### questions

The scripts sourced below complete the following actions: <br> \*
Compute question age by subtracting from 2019-02-01, the day after data
was collected \* Compute the number of tags associated with each
question \* Compute the word count of each question \* Compute the
number of emails sent out regarding each question \* Add
school_mem_status and students_loc_div from the student who submitted
the question \* Derive 9 topical categories through Latent Dirichlet
Allocation, and include the topic assignments

``` r
source("~/GitHub/Career-Village/questions_text_analysis.R")
```

    ## Warning: packages 'dplyr', 'ggplot2', 'stringr', 'topicmodels', 'quanteda',
    ## 'stopwords', 'tidytext', 'quanteda.textplots' are in use and will not be
    ## installed

    ## Installing packages into 'C:/Users/physi/Documents/R/win-library/4.1'
    ## (as 'lib' is unspecified)

    ## also installing the dependencies 'wk', 'tau', 'lars', 'tweenr', 'polyclip', 'classInt', 's2', 'units', 'qdapDictionaries', 'ngramrr', 'stringdist', 'spikeslab', 'textshape', 'dtt', 'ggforce', 'tidygraph', 'graphlayouts', 'V8', 'sf'

    ## package 'wk' successfully unpacked and MD5 sums checked
    ## package 'tau' successfully unpacked and MD5 sums checked
    ## package 'lars' successfully unpacked and MD5 sums checked
    ## package 'tweenr' successfully unpacked and MD5 sums checked
    ## package 'polyclip' successfully unpacked and MD5 sums checked
    ## package 'classInt' successfully unpacked and MD5 sums checked
    ## package 's2' successfully unpacked and MD5 sums checked
    ## package 'units' successfully unpacked and MD5 sums checked
    ## package 'qdapDictionaries' successfully unpacked and MD5 sums checked
    ## package 'ngramrr' successfully unpacked and MD5 sums checked
    ## package 'stringdist' successfully unpacked and MD5 sums checked
    ## package 'spikeslab' successfully unpacked and MD5 sums checked
    ## package 'textshape' successfully unpacked and MD5 sums checked
    ## package 'dtt' successfully unpacked and MD5 sums checked
    ## package 'ggforce' successfully unpacked and MD5 sums checked
    ## package 'tidygraph' successfully unpacked and MD5 sums checked
    ## package 'graphlayouts' successfully unpacked and MD5 sums checked
    ## package 'V8' successfully unpacked and MD5 sums checked
    ## package 'sf' successfully unpacked and MD5 sums checked
    ## package 'tidygeocoder' successfully unpacked and MD5 sums checked
    ## package 'data.table' successfully unpacked and MD5 sums checked

    ## Warning: cannot remove prior installation of package 'data.table'

    ## Warning in file.copy(savedcopy, lib, recursive =
    ## TRUE): problem copying C:\Users\physi\Documents\R\win-
    ## library\4.1\00LOCK\data.table\libs\x64\datatable.dll to C:
    ## \Users\physi\Documents\R\win-library\4.1\data.table\libs\x64\datatable.dll:
    ## Permission denied

    ## Warning: restored 'data.table'

    ## package 'SentimentAnalysis' successfully unpacked and MD5 sums checked
    ## package 'vader' successfully unpacked and MD5 sums checked
    ## package 'syuzhet' successfully unpacked and MD5 sums checked
    ## package 'wordcloud' successfully unpacked and MD5 sums checked
    ## package 'BTM' successfully unpacked and MD5 sums checked
    ## package 'udpipe' successfully unpacked and MD5 sums checked
    ## package 'textplot' successfully unpacked and MD5 sums checked
    ## package 'ggraph' successfully unpacked and MD5 sums checked
    ## package 'concaveman' successfully unpacked and MD5 sums checked
    ## 
    ## The downloaded binary packages are in
    ##  C:\Users\physi\AppData\Local\Temp\RtmpCKsaX8\downloaded_packages

    ## Warning: package 'tidygeocoder' was built under R version 4.1.2

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:reshape2':
    ## 
    ##     dcast, melt

    ## The following object is masked from 'package:purrr':
    ## 
    ##     transpose

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

    ## Warning: package 'SentimentAnalysis' was built under R version 4.1.2

    ## 
    ## Attaching package: 'SentimentAnalysis'

    ## The following object is masked from 'package:base':
    ## 
    ##     write

    ## Warning: package 'vader' was built under R version 4.1.2

    ## Warning: package 'syuzhet' was built under R version 4.1.2

    ## 
    ## Attaching package: 'syuzhet'

    ## The following object is masked from 'package:scales':
    ## 
    ##     rescale

    ## Warning: package 'wordcloud' was built under R version 4.1.2

    ## Loading required package: RColorBrewer

    ## Warning: package 'BTM' was built under R version 4.1.2

    ## Warning: package 'udpipe' was built under R version 4.1.2

    ## Warning: package 'textplot' was built under R version 4.1.2

    ## Warning: package 'ggraph' was built under R version 4.1.2

    ## Warning: package 'concaveman' was built under R version 4.1.2

    ## K = 9; V = 53662; M = 23845
    ## Sampling 600 iterations!
    ## Iteration 25 ...
    ## Iteration 50 ...
    ## Iteration 75 ...
    ## Iteration 100 ...
    ## Iteration 125 ...
    ## Iteration 150 ...
    ## Iteration 175 ...
    ## Iteration 200 ...
    ## Iteration 225 ...
    ## Iteration 250 ...
    ## Iteration 275 ...
    ## Iteration 300 ...
    ## Iteration 325 ...
    ## Iteration 350 ...
    ## Iteration 375 ...
    ## Iteration 400 ...
    ## Iteration 425 ...
    ## Iteration 450 ...
    ## Iteration 475 ...
    ## Iteration 500 ...
    ## Iteration 525 ...
    ## Iteration 550 ...
    ## Iteration 575 ...
    ## Iteration 600 ...
    ## Gibbs sampling completed!

    ## `summarise()` has grouped output by 'Year'. You can override using the `.groups` argument.

``` r
source("~/GitHub/Career-Village/Feature Engineering Scripts/quests__tags_words_emails_topics.R")
```

## Output after preprocessing

``` r
engineered <- c("professionals", "students", "questions")
for (i in 1:length(engineered)) {
  cat(engineered[i], "\n", "\n")
  print(str(get(as.name(engineered[i]))))
  cat('_______________________________________________________________________________________', "\n", "\n")
}
```

    ## professionals 
    ##  
    ## 'data.frame':    28152 obs. of  19 variables:
    ##  $ professionals_id            : chr  "00009a0f9bda43eba47104e9ac62aff5" "000196ef8db54b9a86ae70ad31745d04" "0008138be908438e8944b21f7f57f2c1" "000d4635e5da41e3bfd83677ee11dda4" ...
    ##  $ professionals_location      : chr  "New York, New York" "Chicago, Illinois" "Raipur, India" "Nashville, Tennessee" ...
    ##  $ professionals_industry      : chr  "Other" "Accounting" "Real Estate" "Information Technology and Services" ...
    ##  $ professionals_headline      : chr  "Digital Production & Content Consultant" "Director at PwC" "unspecified" "Director Global Marketing and Sales Strategy DELL" ...
    ##  $ professionals_date_joined   : Date, format: "2016-03-14" "2018-05-15" ...
    ##  $ professionals_loc_div       : Factor w/ 11 levels "East North Central",..: 4 1 3 2 1 8 7 8 11 11 ...
    ##  $ professionals_country       : Factor w/ 150 levels "Afghanistan",..: 143 143 54 143 143 143 94 143 143 143 ...
    ##  $ total_answers               : num  3 0 0 3 0 0 0 0 24 0 ...
    ##  $ avg_ans_word_count          : num  146.7 0 0 51.3 0 ...
    ##  $ avg_ans_num_sents           : num  12 0 0 2.33 0 ...
    ##  $ avg_ans_sent_length         : num  14.1 0 0 27 0 ...
    ##  $ tot_words_written           : num  440 0 0 154 0 ...
    ##  $ professionals_acct_age      : num  1054 262 88 1010 478 ...
    ##  $ email_notification_daily    : num  12 42 0 662 3 10 0 113 19 5 ...
    ##  $ email_notification_immediate: num  2 0 0 283 0 0 0 67 0 0 ...
    ##  $ email_notification_weekly   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ tags_followed               : num  3 1 1 3 1 1 3 16 1 1 ...
    ##  $ total_hearts                : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ total_comments              : num  3 0 0 3 0 0 0 0 24 0 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ##  
    ## students 
    ##  
    ## 'data.frame':    30971 obs. of  12 variables:
    ##  $ students_id         : chr  "0001a66883f74e8d91884fc6ea0d66a7" "0004592176864233990d949862baa2f3" "00069bb26ad64897b2793c81325a4440" "0008238db56e45b9a40a9ddd219fab2f" ...
    ##  $ students_location   : chr  "Henderson, Texas" "Boston, Massachusetts" "Philadelphia, Pennsylvania" "San Francisco, California" ...
    ##  $ students_date_joined: Date, format: "2018-08-21" "2016-03-09" ...
    ##  $ students_loc_div    : Factor w/ 11 levels "East North Central",..: 11 6 4 8 9 10 3 8 11 11 ...
    ##  $ students_country    : Factor w/ 134 levels "Afghanistan",..: 128 128 128 128 128 128 52 128 128 128 ...
    ##  $ students_acct_age   : num  164 1059 982 1417 895 ...
    ##  $ tags_followed       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ school_mem_status   : Factor w/ 3 levels "0","1","2": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ total_questions     : num  2 1 0 0 0 0 0 0 0 0 ...
    ##  $ tot_words_written   : num  47 45 0 0 0 0 0 0 0 0 ...
    ##  $ total_hearts        : num  4 3 0 0 0 0 0 0 0 0 ...
    ##  $ total_comments      : num  2 1 0 0 0 0 0 0 0 0 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ##  
    ## questions 
    ##  
    ## 'data.frame':    23716 obs. of  13 variables:
    ##  $ questions_id        : chr  "332a511f1569444485cf7a7a556a5e54" "eb80205482e4424cad8f16bc25aa2d9c" "4ec31632938a40b98909416bdd0decff" "2f6a9a99d9b24e5baa50d40d0ba50a75" ...
    ##  $ questions_author_id : chr  "8f6f374ffd834d258ab69d376dd998f5" "acccbda28edd4362ab03fb8b6fd2d67b" "f2c179a563024ccc927399ce529094b5" "2c30ffba444e40eabb4583b55233a5a4" ...
    ##  $ questions_date_added: chr  "2016-04-26 11:14:26 UTC+0000" "2016-05-20 16:48:25 UTC+0000" "2017-02-08 19:13:38 UTC+0000" "2017-09-01 14:05:32 UTC+0000" ...
    ##  $ questions_title     : chr  "Teacher   career   question" "I want to become an army officer. What can I do to become an army officer?" "Will going abroad for your first job increase your chances for jobs back home?" "To become a specialist in business  management, will I have to network myself?" ...
    ##  $ questions_body      : chr  "What  is  a  maths  teacher?   what  is  a  maths  teacher  useful? #college #professor #lecture" "I am Priyanka from Bangalore . Now am in 10th std . When I go to college I should not get confused on what I wa"| __truncated__ "I'm planning on going abroad for my first job. It will be a teaching job and I don't have any serious career id"| __truncated__ "i hear business management is a hard way to get a job if you're not known in the right areas. #business #networking " ...
    ##  $ quest_age           : num  1011 987 723 518 518 ...
    ##  $ num_tags            : num  3 2 2 2 4 1 2 3 2 4 ...
    ##  $ num_words           : int  14 38 89 22 26 5 26 28 40 34 ...
    ##  $ students_loc_div    : Factor w/ 11 levels "East North Central",..: 3 6 7 9 9 9 4 8 11 9 ...
    ##  $ school_mem_status   : Factor w/ 3 levels "0","1","2": 1 1 2 1 1 1 1 1 1 1 ...
    ##  $ num_emails          : num  200 62 5 642 320 1 390 260 171 0 ...
    ##  $ topic_lda           : int  5 1 4 3 6 6 2 5 4 7 ...
    ##  $ answered            : num  1 1 1 1 1 1 1 1 1 1 ...
    ## NULL
    ## _______________________________________________________________________________________ 
    ## 
