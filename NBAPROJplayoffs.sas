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
libname nbaproj '/home/u64430304/NBAPROJ';
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

data nbaproj.playoffstats22untouched;
	infile "/home/u64430304/NBAPROJ/nbaplayoffs2022.csv" dsd dlm=';' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
run;

data nbaproj.playoffstats22;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.playoffstats22untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;

***********************************
Point Guards 2022
***********************************;

proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot22;
    set nbaproj.team_pg_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot22;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2022;
***********************************;
proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot22;
    set nbaproj.team_sg_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot22;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2022;
***********************;

proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot22;
    set nbaproj.team_sf_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot22;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2022;
***********************;

proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot22;
    set nbaproj.team_pf_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot22;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2022;
***********************;

proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot22;
    set nbaproj.team_c_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot22;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=left border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2022;
*****************;

proc summary data=nbaproj.playoffstats22 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot22;
    set nbaproj.team_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot22;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2022 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=.1 max=.50;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

**************************;
*2023 playoffs;
**************************;


data nbaproj.playoffstats23untouched;
	infile "/home/u64430304/NBAPROJ/nbaplayoffs2023.csv" dsd dlm=';' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
run;

data nbaproj.playoffstats23;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.playoffstats23untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2023
***********************************;

proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot23;
    set nbaproj.team_pg_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot23;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2023;
***********************************;
proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot23;
    set nbaproj.team_sg_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot23;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2023;
***********************;

proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot23;
    set nbaproj.team_sf_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot23;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2023;
***********************;

proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot23;
    set nbaproj.team_pf_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot23;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2023;
***********************;

proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot23;
    set nbaproj.team_c_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot23;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=left border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2023;
*****************;

proc summary data=nbaproj.playoffstats23 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot23;
    set nbaproj.team_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot23;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2023 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=.1 max=.50;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

************************************
2024 Playoffs
************************************;


data nbaproj.playoffstats24untouched;
	infile "/home/u64430304/NBAPROJ/nbaplayoffs2024.csv" dsd dlm=';' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
run;

data nbaproj.playoffstats24;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.playoffstats24untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2024
***********************************;

proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot24;
    set nbaproj.team_pg_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot24;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2024;
***********************************;
proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot24;
    set nbaproj.team_sg_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot24;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2024;
***********************;

proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot24;
    set nbaproj.team_sf_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot24;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2024;
***********************;

proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot24;
    set nbaproj.team_pf_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot24;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2024;
***********************;

proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot24;
    set nbaproj.team_c_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot24;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=left border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2024;
*****************;

proc summary data=nbaproj.playoffstats24 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot24;
    set nbaproj.team_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot24;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2024 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=.1 max=.50;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;


*****************************
2025 Playoffs
*****************************;


data nbaproj.playoffstats25untouched;
	infile "/home/u64430304/NBAPROJ/nbaplayoffs2025.csv" dsd dlm=',' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Pos $ Age Tm $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
run;

data nbaproj.playoffstats25;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.playoffstats25untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2025
***********************************;

proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot25;
    set nbaproj.team_pg_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot25;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2025;
***********************************;
proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot25;
    set nbaproj.team_sg_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot25;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2025;
***********************;

proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot25;
    set nbaproj.team_sf_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot25;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2025;
***********************;

proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot25;
    set nbaproj.team_pf_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot25;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2025;
***********************;

proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot25;
    set nbaproj.team_c_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot25;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=left border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2025;
*****************;

proc summary data=nbaproj.playoffstats25 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot25;
    set nbaproj.team_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot25;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2025 NBA Playoffs?";
	format Percentage PERCENT7.1;
	yaxis min=.1 max=.50;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;
