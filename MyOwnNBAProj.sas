*
Lucas Curtis
5-13-2026
Project on 3pt shooting in the NBA Playoffs
;

*************************************
OBJECTIVE: Aggregating individual player stats into team performance metrics at certain
aspects of the game (i.e. 3pt shooting) and tying that back to potential impacts on team
success. Used PROC SUMMARY, PROC SGPLOT
*************************************



*RESEARCH QUESTIONS:
   Which team's {position} shot best from 3pt range?
      -This will include variables Tm, _3Ppct, Pos, _3P, _3PA
      -Target variables: _3Ppct, _3P, _3PA
      -Predictor variables: Tm (Team)
      -These variables are renamed at the DATA step for each specific positionial dataset
            - _3Ppct -> Percentage
            - Tm     -> Team
            - _3P    -> Made
            - _3PA   -> Attempted
      -The reference line for "League Average 3P%" changes based on that season
**********************************
Look at Point Guard section for most 
complete code documentation that other positions follow
**********************************

**************************
-Example question this data can help to answer:
In basketball, a team with players at the center position that shoot well
from three point range have a big advantage because centers are not 
typically good three point shooters. Finding the teams that have these 
centers that comfortably shoot from deeper range can help explain 
team success.
**************************
;

libname nbaproj '/home/u64430304/projectst307';

******************************************
Data step- data obtained from Kaggle, link is 
https://www.kaggle.com/datasets/vivovinco/nba-player-stats. 
Further years, of which are also used in this research, can also be found here.
A user on Kaggle took the stats from Basketball-Reference.com 
and put them on Kaggle for use. This data is collected through nba playoff seasons.
******************************************
;

*******************************;
*2022 PLAYOFFS;
*******************************;
data nbaproj.playoffstats22;
  infile "/home/u64430304/projectst307/nbaplayoffs2022.csv"
    dsd dlm=';' firstobs=2; 
  attrib Rk                   
         Player length= $30.; *extends space for player name variable, and keeps Rk in front;
  input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct 
  _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
  ORB DRB TRB AST STL BLK TOV PF PTS;
run;

***********************************
Point Guards 2022
***********************************;
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
 class Tm;
 where Pos = "PG";
 var _3P _3PA;
              output out = nbaproj.team_pg_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot22; 
*new dataset made specifically for this problem;
 set nbaproj.Team_pg_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 *IMPORTANT- Renamed these variables and used the new variable names in code proceeding,
 I did this separately for each position;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
 *The above 4 lines grabs the attention of all numeric values and replaces the missing
  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot22;  *TABULAR OUTPUT;
 title "What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1; *shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %"; *X AND Y AXIS LABELS;
  title "What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1; *Graph shows % numbers on Y Axis Scale;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^ Each different position is scaled differently due to differences
                        in general 3pt ability. i.e. Centers shoot less threes;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2022;
***********************************;   
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
 class Tm;
 where Pos = "SG";
 var _3P _3PA;
              output out = nbaproj.team_sg_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats by shooting guard';
run;
     
data nbaproj.sgshoot22; 
*new dataset specifically for the shooting guard problem;
 set nbaproj.Team_sg_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sgshoot22;  *TABULAR OUTPUT;
 title "What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star) ; 
     *scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2022;
***********************;
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats by sf position;
 class Tm;
 where Pos = "SF";
 var _3P _3PA;
              output out = nbaproj.team_sf_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot22; 
*new dataset specifically for the sf problem;
 set nbaproj.Team_sf_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sfshoot22;  *TABULAR OUTPUT;
 title "What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2022;
***********************;
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats by pf position;
 class Tm;
 where Pos = "PF";
 var _3P _3PA;
              output out = nbaproj.team_pf_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot22; 
*new dataset specifically for the pf problem;
 set nbaproj.Team_pf_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pfshoot22;  *TABULAR OUTPUT;
 title "What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=6.5; 
   *scaling the axis' ^;
    refline 3.5 / axis=x 
      label= "Over 3.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************;
*Centers 2022;
***********************;
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats by center position;
 class Tm;
 where Pos = "C";
 var _3P _3PA;
              output out = nbaproj.team_center_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot22; 
*new dataset specifically for the center problem;
 set nbaproj.Team_center_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.centershoot22;  *TABULAR OUTPUT;
 title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=3; 
   *scaling the axis' ^;
    refline 1.5 / axis=x 
      label= "Over 1.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = left border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


*****************;
*ALL POSITIONS INCLUDED 2022;
*****************;
proc summary data=nbaproj.playoffstats22; 
*this makes a dataset with each teams total 3pt volume stats;
 class Tm;
 var _3P _3PA;
              output out = nbaproj.team_thrpt_stats22
                sum = _3P _3PA;
 title 'filters team 3pt stats';
run;

data nbaproj.teamshoot22; 
*new dataset specifically for the positionless problem;
 set nbaproj.Team_thrpt_stats22 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot22;  *TABULAR OUTPUT;
 title "What teams shot the best from 3 in the 2022 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot22; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What teams shot the best from 3 in the 2022 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=.1 max=.50; 
   xaxis min=7.5 max=17.5; 
   *scaling the axis' ^;
    refline 13 / axis=x 
      label= "Over 13 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .354 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



**************************;
*2023 playoffs;
**************************;
data nbaproj.playoffstats23;
  infile "/home/u64430304/projectst307/nbaplayoffs2023.csv"
    dsd dlm=';' firstobs=2; 
  attrib Rk                   
         Player length= $30.; *extends space for player name variable, and keeps Rk in front;
  input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct 
  _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
  ORB DRB TRB AST STL BLK TOV PF PTS;
run;

***********************************
Point Guards 2023
***********************************;
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
 class Tm;
 where Pos = "PG";
 var _3P _3PA;
              output out = nbaproj.team_pg_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot23; 
*new dataset made specifically for this problem;
 set nbaproj.Team_pg_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 *IMPORTANT- Renamed these variables and used the new variable names in code proceeding,
 I did this separately for each position;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pgshoot23;  *TABULAR OUTPUT;
 title "What team's Point Guards shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1; *shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %"; *X AND Y AXIS LABELS;
  title "What team's Point Guards shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1; *Graph shows % numbers on Y Axis Scale;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^ Each different position is scaled differently due to differences
                        in general 3pt ability. i.e. Centers shoot less threes;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************************;
*SHOOTING GUARDS 2023;
***********************************;   
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
 class Tm;
 where Pos = "SG";
 var _3P _3PA;
              output out = nbaproj.team_sg_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats by shooting guard';
run;
     
data nbaproj.sgshoot23; 
*new dataset specifically for the shooting guard problem;
 set nbaproj.Team_sg_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sgshoot23;  *TABULAR OUTPUT;
 title "What team's Shooting Guards shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Shooting Guards shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star) ; 
     *scatter plot + options ^ ;
run;


***********************;
*Small Forwards 2023;
***********************;
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats by sf position;
 class Tm;
 where Pos = "SF";
 var _3P _3PA;
              output out = nbaproj.team_sf_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot23; 
*new dataset specifically for the sf problem;
 set nbaproj.Team_sf_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sfshoot23;  *TABULAR OUTPUT;
 title "What team's Small Forwards shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Small Forwards shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


***********************;
*Power Forwards 2023;
***********************;
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats by pf position;
 class Tm;
 where Pos = "PF";
 var _3P _3PA;
              output out = nbaproj.team_pf_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot23; 
*new dataset specifically for the pf problem;
 set nbaproj.Team_pf_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pfshoot23;  *TABULAR OUTPUT;
 title "What team's Power Forwards shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Power Forwards shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=6.5; 
   *scaling the axis' ^;
    refline 3.5 / axis=x 
      label= "Over 3.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************;
*Centers 2023;
***********************;
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats by center position;
 class Tm;
 where Pos = "C";
 var _3P _3PA;
              output out = nbaproj.team_center_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot23; 
*new dataset specifically for the center problem;
 set nbaproj.Team_center_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.centershoot23;  *TABULAR OUTPUT;
 title "What team's Centers shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Centers shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=3; 
   *scaling the axis' ^;
    refline 1.5 / axis=x 
      label= "Over 1.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = left border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


*****************;
*ALL POSITIONS INCLUDED 2023;
*****************;
proc summary data=nbaproj.playoffstats23; 
*this makes a dataset with each teams total 3pt volume stats;
 class Tm;
 var _3P _3PA;
              output out = nbaproj.team_thrpt_stats23
                sum = _3P _3PA;
 title 'filters team 3pt stats';
run;

data nbaproj.teamshoot23; 
*new dataset specifically for the positionless problem;
 set nbaproj.Team_thrpt_stats23 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot23;  *TABULAR OUTPUT;
 title "What teams shot the best from 3 in the 2023 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot23; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What teams shot the best from 3 in the 2023 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=.1 max=.50; 
   xaxis min=7.5 max=17.5; 
   *scaling the axis' ^;
    refline 13 / axis=x 
      label= "Over 13 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .361 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;

************************************
2024 Playoffs
************************************;

data nbaproj.playoffstats24;
  infile "/home/u64430304/projectst307/nbaplayoffs2024.csv"
    dsd dlm=';' firstobs=2; 
  attrib Rk                   
         Player length= $30.; *extends space for player name variable, and keeps Rk in front;
  input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct 
  _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
  ORB DRB TRB AST STL BLK TOV PF PTS;
run;

***********************************
Point Guards 2024
***********************************;
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
 class Tm;
 where Pos = "PG";
 var _3P _3PA;
              output out = nbaproj.team_pg_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot24; 
*new dataset made specifically for this problem;
 set nbaproj.Team_pg_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 *IMPORTANT- Renamed these variables and used the new variable names in code proceeding,
 I did this separately for each position;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pgshoot24;  *TABULAR OUTPUT;
 title "What team's Point Guards shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1; *shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %"; *X AND Y AXIS LABELS;
  title "What team's Point Guards shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1; *Graph shows % numbers on Y Axis Scale;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^ Each different position is scaled differently due to differences
                        in general 3pt ability. i.e. Centers shoot less threes;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************************;
*SHOOTING GUARDS 2024;
***********************************;   
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
 class Tm;
 where Pos = "SG";
 var _3P _3PA;
              output out = nbaproj.team_sg_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats by shooting guard';
run;
     
data nbaproj.sgshoot24; 
*new dataset specifically for the shooting guard problem;
 set nbaproj.Team_sg_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sgshoot24;  *TABULAR OUTPUT;
 title "What team's Shooting Guards shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Shooting Guards shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star) ; 
     *scatter plot + options ^ ;
run;


***********************;
*Small Forwards 2024;
***********************;
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats by sf position;
 class Tm;
 where Pos = "SF";
 var _3P _3PA;
              output out = nbaproj.team_sf_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot24; 
*new dataset specifically for the sf problem;
 set nbaproj.Team_sf_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sfshoot24;  *TABULAR OUTPUT;
 title "What team's Small Forwards shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Small Forwards shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


***********************;
*Power Forwards 2024;
***********************;
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats by pf position;
 class Tm;
 where Pos = "PF";
 var _3P _3PA;
              output out = nbaproj.team_pf_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot24; 
*new dataset specifically for the pf problem;
 set nbaproj.Team_pf_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pfshoot24;  *TABULAR OUTPUT;
 title "What team's Power Forwards shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Power Forwards shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=6.5; 
   *scaling the axis' ^;
    refline 3.5 / axis=x 
      label= "Over 3.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************;
*Centers 2024;
***********************;
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats by center position;
 class Tm;
 where Pos = "C";
 var _3P _3PA;
              output out = nbaproj.team_center_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot24; 
*new dataset specifically for the center problem;
 set nbaproj.Team_center_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.centershoot24;  *TABULAR OUTPUT;
 title "What team's Centers shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Centers shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=3.5; 
   *scaling the axis' ^;
    refline 1.5 / axis=x 
      label= "Over 1.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)
                          ; 
     *scatter plot + options ^ ;
run;


*****************;
*ALL POSITIONS INCLUDED 2024;
*****************;
proc summary data=nbaproj.playoffstats24; 
*this makes a dataset with each teams total 3pt volume stats;
 class Tm;
 var _3P _3PA;
              output out = nbaproj.team_thrpt_stats24
                sum = _3P _3PA;
 title 'filters team 3pt stats';
run;

data nbaproj.teamshoot24; 
*new dataset specifically for the positionless problem;
 set nbaproj.Team_thrpt_stats24 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot24;  *TABULAR OUTPUT;
 title "What teams shot the best from 3 in the 2024 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot24; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What teams shot the best from 3 in the 2024 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=.1 max=.50; 
   xaxis min=7.5 max=17.5; 
   *scaling the axis' ^;
    refline 13 / axis=x 
      label= "Over 13 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .366 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;

*****************************
2025 Playoffs
*****************************;

data nbaproj.playoffstats25;
  infile "/home/u64430304/projectst307/nbaplayoffs2025.csv"
    dsd dlm=',' firstobs=2; 
  attrib Rk                   
         Player length= $30.; *extends space for player name variable, and keeps Rk in front;
  input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct 
  _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
  ORB DRB TRB AST STL BLK TOV PF PTS;
run;

***********************************
Point Guards 2025
***********************************;
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
 class Tm;
 where Pos = "PG";
 var _3P _3PA;
              output out = nbaproj.team_pg_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot25; 
*new dataset made specifically for this problem;
 set nbaproj.Team_pg_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 *IMPORTANT- Renamed these variables and used the new variable names in code proceeding,
 I did this separately for each position;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pgshoot25;  *TABULAR OUTPUT;
 title "What team's Point Guards shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1; *shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %"; *X AND Y AXIS LABELS;
  title "What team's Point Guards shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1; *Graph shows % numbers on Y Axis Scale;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^ Each different position is scaled differently due to differences
                        in general 3pt ability. i.e. Centers shoot less threes;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************************;
*SHOOTING GUARDS 2025;
***********************************;   
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
 class Tm;
 where Pos = "SG";
 var _3P _3PA;
              output out = nbaproj.team_sg_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats by shooting guard';
run;
     
data nbaproj.sgshoot25; 
*new dataset specifically for the shooting guard problem;
 set nbaproj.Team_sg_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sgshoot25;  *TABULAR OUTPUT;
 title "What team's Shooting Guards shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Shooting Guards shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=9; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star) ; 
     *scatter plot + options ^ ;
run;


***********************;
*Small Forwards 2025;
***********************;
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats by sf position;
 class Tm;
 where Pos = "SF";
 var _3P _3PA;
              output out = nbaproj.team_sf_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot25; 
*new dataset specifically for the sf problem;
 set nbaproj.Team_sf_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.sfshoot25;  *TABULAR OUTPUT;
 title "What team's Small Forwards shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Small Forwards shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


***********************;
*Power Forwards 2025;
***********************;
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats by pf position;
 class Tm;
 where Pos = "PF";
 var _3P _3PA;
              output out = nbaproj.team_pf_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot25; 
*new dataset specifically for the pf problem;
 set nbaproj.Team_pf_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.pfshoot25;  *TABULAR OUTPUT;
 title "What team's Power Forwards shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Power Forwards shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=6.5; 
   *scaling the axis' ^;
    refline 3.5 / axis=x 
      label= "Over 3.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;



***********************;
*Centers 2025;
***********************;
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats by center position;
 class Tm;
 where Pos = "C";
 var _3P _3PA;
              output out = nbaproj.team_center_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot25; 
*new dataset specifically for the center problem;
 set nbaproj.Team_center_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 array VariablesOfInterest _numeric_;
   do over VariablesOfInterest;
     if VariablesOfInterest =. then VariablesOfInterest=0;
 end;
run;

proc print data=nbaproj.centershoot25;  *TABULAR OUTPUT;
 title "What team's Centers shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Centers shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=0 max=.60; 
   xaxis min=0 max=3; 
   *scaling the axis' ^;
    refline 1.5 / axis=x 
      label= "Over 1.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;


*****************;
*ALL POSITIONS INCLUDED 2025;
*****************;
proc summary data=nbaproj.playoffstats25; 
*this makes a dataset with each teams total 3pt volume stats;
 class Tm;
 var _3P _3PA;
              output out = nbaproj.team_thrpt_stats25
                sum = _3P _3PA;
 title 'filters team 3pt stats';
run;

data nbaproj.teamshoot25; 
*new dataset specifically for the positionless problem;
 set nbaproj.Team_thrpt_stats25 (firstobs=2);
 _3Ppct = (_3p / _3PA) ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot25;  *TABULAR OUTPUT;
 title "What teams shot the best from 3 in the 2025 NBA Playoffs?";
 format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot25; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What teams shot the best from 3 in the 2025 NBA Playoffs?";
   format Percentage PERCENT7.1;
   yaxis min=.1 max=.50; 
   xaxis min=7.5 max=17.5; 
   *scaling the axis' ^;
    refline 13 / axis=x 
      label= "Over 13 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline .360 / axis=y 
      label= "League Average 3P%" 
        lineattrs= (color=red)
        labelattrs = (color=red);
     *adding reference lines ^ ;
     inset "High Volume, High Efficiency" / position = topright border;
     inset "Low Volume, High Efficiency" / position = topleft border;
     inset "Low Volume, Low Efficiency" / position = bottomleft border;
     inset "High Volume, Low Efficiency" / position = bottomright border; 
     *adding text inside box ^ ;
 scatter x=Made y=Percentage / group=Team 
                          datalabel=Team   
                          jitter 
                          markerattrs= (symbol=star)  ; 
     *scatter plot + options ^ ;
run;




