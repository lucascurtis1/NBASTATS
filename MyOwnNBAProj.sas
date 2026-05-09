*
Lucas Curtis
5-3-2026
Project on NBA 3pt shooting in the 2021-22 NBA Playoffs
;

*RESEARCH QUESTIONS:
   Which team's {position} shot best from 3pt range?
      -This will include variables Tm, _3Ppct, Pos, _3P, _3PA
Target variables: _3Ppct, _3P, _3PA
Predictor variables: Tm (Team)

Look at Point Guard section for most 
complete code documentation that other positions follow

Example question this data can help to answer:
In basketball, a team with good three point shooting centers have a big advantage 
since traditionally centers are not good at shooting three pointers. Finding the 
teams that have these centers that comfortably shoot from deeper range can help explain 
team success.
;

libname nbaproj '/home/u64430304/projectst307';

*
Data step- data obtained from Kaggle, link is 
https://www.kaggle.com/datasets/vivovinco/nba-player-stats.
A user on Kaggle took the stats from Basketball-Reference.com 
and put them on Kaggle for use. This data was collected through 
the 2021-2022 NBA Season + Playoffs.
30 Columns, 217 rows.
;
data nbaproj.playoffstats;
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
Point Guards
***********************************;
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
 class Tm;
 where Pos = "PG";
 var _3P _3PA;
              output out = nbaproj.team_pg_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot; 
*new dataset made specifically for this problem;
 set nbaproj.Team_pg_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
 *IMPORTANT- Renamed these variables and used the new variable names in code proceeding,
 I did this separately for each position;
run;

proc print data=nbaproj.pgshoot;  *TABULAR OUTPUT;
 title "What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.pgshoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %"; *X AND Y AXIS LABELS;
  title "What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=0 max=60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^ Each different position is scaled differently due to differences
                        in general 3pt ability. i.e. Centers shoot less threes;
    refline 4.5 / axis=x 
      label= "Over 4.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
*SHOOTING GUARDS;
***********************************;   
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
 class Tm;
 where Pos = "SG";
 var _3P _3PA;
              output out = nbaproj.team_sg_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats by shooting guard';
run;
     
data nbaproj.sgshoot; 
*new dataset specifically for the shooting guard problem;
 set nbaproj.Team_sg_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.sgshoot;  *TABULAR OUTPUT;
 title "What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.sgshoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=0 max=60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 5 / axis=x 
      label= "Over 5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
*Small Forwards;
***********************;
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats by sf position;
 class Tm;
 where Pos = "SF";
 var _3P _3PA;
              output out = nbaproj.team_sf_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot; 
*new dataset specifically for the sf problem;
 set nbaproj.Team_sf_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.sfshoot;  *TABULAR OUTPUT;
 title "What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.sfshoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=0 max=60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 5 / axis=x 
      label= "Over 5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
*Power Forwards;
***********************;
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats by pf position;
 class Tm;
 where Pos = "PF";
 var _3P _3PA;
              output out = nbaproj.team_pf_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot; 
*new dataset specifically for the pf problem;
 set nbaproj.Team_pf_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 format _3Ppct 20.2;
 drop _TYPE_;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.pfshoot;  *TABULAR OUTPUT;
 title "What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.pfshoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=0 max=60; 
   xaxis min=0 max=8.5; 
   *scaling the axis' ^;
    refline 5 / axis=x 
      label= "Over 5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
*Centers;
***********************;
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats by center position;
 class Tm;
 where Pos = "C";
 var _3P _3PA;
              output out = nbaproj.team_center_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot; 
*new dataset specifically for the center problem;
 set nbaproj.Team_center_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.centershoot;  *TABULAR OUTPUT;
 title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.centershoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=0 max=60; 
   xaxis min=0 max=3; 
   *scaling the axis' ^;
    refline 1.5 / axis=x 
      label= "Over 1.5 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
*ALL POSITIONS INCLUDED;
*****************;
proc summary data=nbaproj.playoffstats; 
*this makes a dataset with each teams total 3pt volume stats;
 class Tm;
 var _3P _3PA;
              output out = nbaproj.team_thrpt_stats
                sum = _3P _3PA;
 title 'filters team 3pt stats';
run;

data nbaproj.teamshoot; 
*new dataset specifically for the positionless problem;
 set nbaproj.Team_thrpt_stats (firstobs=2);
 _3Ppct = (_3p / _3PA) * 100 ;
 drop _TYPE_;
 format _3Ppct 20.2;
 rename _FREQ_= Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot;  *TABULAR OUTPUT;
 title "What teams shot the best from 3 in the 2022 NBA Playoffs?";
run;

proc sgplot data=nbaproj.teamshoot; *GRAPHICAL OUTPUT;
 label Made = "3PT Shots Made" 
       Percentage = "3PT Shot %";
  title "What teams shot the best from 3 in the 2022 NBA Playoffs?"; 
   yaxis min=25 max=50; 
   xaxis min=7.5 max=17.5; 
   *scaling the axis' ^;
    refline 13 / axis=x 
      label= "Over 13 3PM/G" 
        lineattrs= (color=red)
        labelattrs= (color=red);
    refline 35.4 / axis=y 
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
