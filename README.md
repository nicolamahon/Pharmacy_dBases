# Pharmacy_dBases
Database Model for Community Pharmacy

This project was to design a computerised system to handle the stock of products for a community pharmacy. The schema for this computerised database was designed using Erwin Data Modeler and can be viewed in the attached .erwin file. The database was populated and queried using SQL. It was originally implmented using SQL Developer. 

Beyond receiving a case study for the model, all other details are my design and implementation. My design included an number of integrity supports through the use of constraints. Integrity was supported with the appropriate use of Primary keys to ensure Entity Integrity, as well as Foreign keys which supported Referential Integrity. Part of my design included the use of weak entities to facilitate a number of many-to-many relationships within the database. 

My schema included some additonal constraints to ensure Data Integrity. For instance in the inserting of any email addresses into the database included contraints around the formatting of the emails. 

The computerised system in this case study was required to maintain various details about staff, products, suppliers, customers, doctors and prescriptions. In addition, a number of queries needed to be designed to facilitate the printing of labels and prescription details by the pharmacy staff. A common feature of a computerised system is the ability to query non-business data, such as employee sales figures and pharmacists' despensing records. In order to complete the system design, I included a sample of these queries, designed in SQL, to facilitate data outputs. In a completed GUI for a computerised system such as this, these queries would be programmed into a number of buttons, displayed on the UI, in order to faciliate the staff's real world needs of the system, and not make them learn SQL!
