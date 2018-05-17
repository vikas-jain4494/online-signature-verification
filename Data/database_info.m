clc;
clear all;
close all;

load GDatabase_task2;
% GDatabse is a 3 dimensional cell object. The value of 1st and 2nd 
% dimension indicates user no and sign no respectively. The 3rd dimension
% indicates the databse number. 1 for SVC2004, 2 for SUSIG and 3 for
% MCYT-100
SignDatabase=GDatabase(:,:,3);% 1 means SVC2004
gen_cell=SignDatabase{1,1};% retrieving the genuine signature cell 
forg_cell=SignDatabase{1,2};% retrieving the forgery signature cell 
users=SignDatabase{1,3};% total users or signers in svc2004 database
no_gen_sign=SignDatabase{1,4};% No. of genuine signatures per user
no_forg_sign=SignDatabase{1,5};% No. of forgery signatures per user
%% Accessing features' or multidimensional time series
% Time series of SVC2004 has 7 dimension i.e. number of variables are 7
% 1. x-coordinate, 2. y-coordinate 3. pressure button status 1 = pen down 0 = pen up
% 4. pressure exerted by pen  5. azimuth angle 6. altitutde angle 7. time
g_ftr=gen_cell{1,4}; % Accessing time series of 1st user's 4th genuine signature
f_ftr=forg_cell{4,2};% Accessing forgery signature's time series
% users = 40 no_gen_sign = 20, no_forg_sign=20 for each user of SVC2004 database.
%% Details of SUSIG databse
% Time series of signature of SUSIG database has 5 dimension i.e. 5 variables
% 1. x-coordinate 2. y-coordinate 3.stroke end points of pen up = 1 and pen down-0 just opposite
% to SVC2004 database 4. pressure 5. time
% users = 94 no_gen_sign = 20, no_forg_sign=10 for each user of SVC2004 database.
%% Details of MCYT-100
% Time series of signature of MCYT-100 database has 5 dimension i.e. 5 variables
% 1. x-coordinate 2. y-coordinate 3.pressure 4. azimuth angle 5. altitude
% users = 100 no_gen_sign = 25, no_forg_sign=25 for each user of SVC2004 database.
