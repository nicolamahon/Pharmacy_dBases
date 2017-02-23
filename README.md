# Pharmacy_dBases
Database Model for Community Pharmacy

This project was to design a computerised system to handle the stock of products for a community pharmacy, as well as various details about staff, products, suppliers, customers, doctors and prescriptions. The schema for this computerised database was designed using Erwin Data Modeler and can be viewed in the attached .erwin file. The database was populated and queried using SQL. It was originally implemented using SQL Developer. 

Beyond receiving a case study for the model, all other details are my design and implementation. My design included a number of integrity supports through the use of constraints. Integrity was supported with the appropriate use of Primary keys to ensure Entity Integrity, as well as Foreign keys which supported Referential Integrity. Part of my design included the use of weak entities to facilitate a number of many-to-many relationships within the database. 

My schema included some additional value constraints added at column level to ensure Domain Integrity. Where values could not be NULL, where data had to be of a certain type, where values were numeric they were controlled with scale and precision. Additional value constraints were added at table level. For instance in the inserting of any email addresses, values had to contain the '@' symbol.  

In addition, I designed a number of queries to facilitate the printing of labels and prescription details by the pharmacy staff. A common feature of a computerised system is the ability to query non-business data, such as employee sales figures and pharmacists' despensing records. In order to complete the system design, I included a sample of these queries, designed in SQL, to facilitate data output. In a completed GUI for a computerised system such as this, these queries would be programmed into a number of buttons, displayed on the UI, in order to faciliate the staff's real world needs of the system, and not make them learn SQL!
