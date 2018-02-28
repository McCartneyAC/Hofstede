// name:  Data Management Final Project 2017
// name:  MAIN PROJECT DO FILE 
// author: Andrew McCartney
// date: 12-10-2017





******
// Okay, what if you have them all as "value" and use a local to loop through
// renaming them *as* they are imported in that loop on lines 53 and 60. 
// that would be hella impressive.

// also a single loop to import both MDG and SDG?

// drop if countryorarea contains "(" ?????
******


// Reset global drive name prior to running any code:
global drive E:\
//global directory "${drive}hofstede"

cd "${drive}do_files"

//// There exist three do files for various purposes, which are:

// merge all datasets and clean where needed
do mergedata 
* Because of the nature of 41 of the .csv files being imported, cleaning and merging
* must be done in interlocking steps, necessitating only one .do file for this process.


// generate data analysis outputs and table outputs
do analysis


// generate graphs and data visualizations
do visualizations
* this will generate *myriad* graphs, of which 6 will be saved. They will all
* disappear from view, but can be found on this file under "${drive}datavis"



exit
