# Pharmacy_dBases
Database Model for Community Pharmacy

This project was to design a computerised system to handle the stock of products for a community pharmacy. The schema for teh database was designed using Erwin Data Modeler and can be viewed in the attached .erwin file. The database was populated and queried using SQL. It was originally implmented using SQL Developer. 

The computerised system in this case study was required to maintain various details about staff, products, suppliers, customers, doctors and prescriptions. Some of the data fields are outlined below. 

Staff Details:
- staff ID
- name
- address
- telephone number
- email address
- PPS number
- staff role (e.g. counter staff, pharmacist, stock clerk etc.)

Product Details:
- stock code
- description
- cost and retail prices
- drug or non-drug type
- brand
- quanity / pack size

Supplier Details:
- supplier ID
- name
- address
- telephone number

Customer Details: 
- customer ID
- name
- address
- contact details
- medical card number (if any) Each customer within the system has a unique ID.

Doctor Details: 
- doctor ID
- name
- surgery name
- surgery address

Prescription Details:
- prescription ID
- customer ID
- prescribing doctor ID
- product stock code
- logging staff
- dispensing staff
- collected date/time
- payment type
