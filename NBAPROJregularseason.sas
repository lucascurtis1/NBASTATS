*
LUCAS CURTIS
5 27 2026
Project on 3pt shooting, regular season
;

*
data from sports-reference.com
for use with this code, get regular season player stats into csv format and then 
-delete columns: Awards Player-Additional
-rename column: 'Team' -> 'Tm'
-delimeter is comma
-for regular season, firstobs is 3 in data step
;
libname nbaproj '/home/u64430304/NBAPROJ';

data nbaproj.Regular_Seasonstats22unfinish;
	infile "/home/u64430304/NBAPROJ/nbaregular2022.csv" dsd dlm=',' 
		firstobs=3;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Age Tm $ Pos $
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
run;

data nbaproj.Regular_Seasonstats22;
    set nbaproj.Regular_Seasonstats22;
    if Tm = '3TM' or Tm = '2TM' or Tm = '4TM' then delete;
run;

***********************************
Point Guards 2022
***********************************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats by position, in this case pg;
	class Tm;
	where Pos="PG";
	var _3P _3PA;
	output out=nbaproj.team_pg_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats by Point Guard';
run;

data nbaproj.pgshoot22_reg;
	*new dataset made specifically for this problem;
	set nbaproj.Team_pg_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	format _3Ppct 20.2;
	drop _TYPE_;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
	*IMPORTANT- Renamed these variables and used the new variable names in code proceeding,

		 I did this separately for each position;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot22_reg;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=.20 max=.55;
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2022;
***********************************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats by shooting guard position;
	class Tm;
	where Pos="SG";
	var _3P _3PA;
	output out=nbaproj.team_sg_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats by shooting guard';
run;

data nbaproj.sgshoot22_reg;
	*new dataset specifically for the shooting guard problem;
	set nbaproj.Team_sg_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	drop _TYPE_;
	format _3Ppct 20.2;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
run;

proc print data=nbaproj.sgshoot22_reg;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	yaxis min=.20 max=.55;
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2022;
***********************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats by sf position;
	class Tm;
	where Pos="SF";
	var _3P _3PA;
	output out=nbaproj.team_sf_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats by Small Forward';
run;

data nbaproj.sfshoot22_reg;
	*new dataset specifically for the sf problem;
	set nbaproj.Team_sf_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	format _3Ppct 20.2;
	drop _TYPE_;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
run;

proc print data=nbaproj.sfshoot22_reg;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	yaxis min=.20 max=.55;
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2022;
***********************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats by pf position;
	class Tm;
	where Pos="PF";
	var _3P _3PA;
	output out=nbaproj.team_pf_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats by Power Forward';
run;

data nbaproj.pfshoot22_reg;
	*new dataset specifically for the pf problem;
	set nbaproj.Team_pf_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	format _3Ppct 20.2;
	drop _TYPE_;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
run;

proc print data=nbaproj.pfshoot22_reg;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	yaxis min=.20 max=.55;
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2022;
***********************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats by center position;
	class Tm;
	where Pos="C";
	var _3P _3PA;
	output out=nbaproj.team_center_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats by center';
run;

data nbaproj.centershoot22_reg;
	*new dataset specifically for the center problem;
	set nbaproj.Team_center_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	drop _TYPE_;
	format _3Ppct 20.2;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
run;

proc print data=nbaproj.centershoot22_reg;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
	yaxis min=.20 max=.55;
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2022;
*****************;

proc summary data=nbaproj.Regular_Seasonstats22;
	*this makes a dataset with each teams total 3pt volume stats;
	class Tm;
	var _3P _3PA;
	output out=nbaproj.team_thrpt_stats22 sum=_3P _3PA;
	title 'filters team 3pt stats';
run;

data nbaproj.teamshoot22_reg;
	*new dataset specifically for the positionless problem;
	set nbaproj.Team_thrpt_stats22 (firstobs=2);
	_3Ppct=(_3p / _3PA);
	drop _TYPE_;
	format _3Ppct 20.2;
	rename _FREQ_=Pos_Quantity _3P=Made _3PA=Attempted _3Ppct=Percentage Tm=Team;
run;

proc print data=nbaproj.teamshoot22_reg;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2022 NBA Regular_Seasons?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot22_reg;
	*GRAPHICAL OUTPUT;
	label Made="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2022 NBA Regular_Seasons?";
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
	scatter x=Made y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;
