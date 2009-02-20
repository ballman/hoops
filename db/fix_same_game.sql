select g1.id, g2.id, g1.played_on
  from games g1, games g2
 where g1.home_team_id = g2.visit_team_id
   and g1.played_on = g2.played_on
   and g1.played_on > '2007-08-01'
   and g1.id>g2.id
 order by g1.played_on;



update team_games set game_id = 10429 where game_id = 10428;
update game_files set game_id = 10429 where game_id = 10428;
delete from games where id = 10428;
update games set neutral_site = true where id= 10429;

update team_games set game_id = 10431 where game_id = 10434;
update game_files set game_id = 10431 where game_id = 10434;
delete from games where id = 10434;
update games set neutral_site = true where id= 10431;

update games set neutral_site = true where id= 10438;

update games set neutral_site = true where id= 10472;

update team_games set game_id = 10473 where game_id = 10513;
update game_files set game_id = 10473 where game_id = 10513;
delete from games where id = 10513;
update games set neutral_site = true where id= 10473;

update games set neutral_site = true where id= 10444;

update team_games set game_id = 10510 where game_id = 10486;
update game_files set game_id = 10510 where game_id = 10486;
delete from games where id = 10486;
update games set neutral_site = true where id= 10510;

update games set neutral_site = true where id= 10496;

update team_games set game_id = 10442 where game_id = 10508;
update game_files set game_id = 10442 where game_id = 10508;
delete from games where id = 10508;
update games set neutral_site = true where id= 10442;

update games set neutral_site = true where id= 10523;

update team_games set game_id = 10530 where game_id = 10551;
update game_files set game_id = 10530 where game_id = 10551;
delete from games where id = 10551;
update games set neutral_site = true where id= 10530;

update games set neutral_site = true where id= 10555;

update team_games set game_id = 10565 where game_id = 10541;
update game_files set game_id = 10565 where game_id = 10541;
delete from games where id = 10541;
update games set neutral_site = true where id= 10565;

update team_games set game_id = 10566 where game_id = 10548;
update game_files set game_id = 10566 where game_id = 10548;
delete from games where id = 10548;
update games set neutral_site = true where id= 10566;

update team_games set game_id =  10563 where game_id = 10567;
update game_files set game_id = 10563 where game_id = 10567;
delete from games where id = 10567;
update games set neutral_site = true where id= 10563;

update team_games set game_id = 10604 where game_id = 10574;
update game_files set game_id = 10604 where game_id = 10574;
delete from games where id = 10574;
update games set neutral_site = true where id= 10604;

update team_games set game_id = 10603 where game_id = 10590;
update game_files set game_id = 10603 where game_id = 10590;
delete from games where id = 10590;
update games set neutral_site = true where id= 10603;

update team_games set game_id = 10605 where game_id = 10594;
update game_files set game_id = 10605 where game_id = 10594;
delete from games where id = 10594;
update games set neutral_site = true where id= 10605;

update team_games set game_id = 10606 where game_id = 10595;
update game_files set game_id = 10606 where game_id = 10595;
delete from games where id = 10595;
update games set neutral_site = true where id= 10606;

update team_games set game_id = 10578 where game_id = 10608;
update game_files set game_id = 10578 where game_id = 10608;
delete from games where id = 10608;
update games set neutral_site = true where id= 10578;

update games set neutral_site = true where id= 10599;
update games set neutral_site = true where id= 10626;
update games set neutral_site = true where id= 10641;
update games set neutral_site = true where id= 10636;
update games set neutral_site = true where id= 10623;

update team_games set game_id = 10680 where game_id = 10676;
update game_files set game_id = 10680 where game_id = 10676;
delete from games where id = 10676;
update games set neutral_site = true where id= 10680;

update team_games set game_id = 10679 where game_id = 10664;
update game_files set game_id = 10679 where game_id = 10664;
delete from games where id = 10664;
update games set neutral_site = true where id= 10679;

update team_games set game_id = 10678 where game_id = 10643;
update game_files set game_id = 10678 where game_id = 10643;
delete from games where id = 10643;
update games set neutral_site = true where id= 10678;

update games set neutral_site = true where id= 10642;
update games set neutral_site = true where id= 10670;

update team_games set game_id = 10723 where game_id = 10707;
update game_files set game_id = 10723 where game_id = 10707;
delete from games where id = 10707;
update games set neutral_site = true where id= 10723;

update games set neutral_site = true where id= 10702;
update games set neutral_site = true where id= 10724;

update team_games set game_id = 10746 where game_id = 10755;
update game_files set game_id = 10746 where game_id = 10755;
delete from games where id = 10755;
update games set neutral_site = true where id= 10746;

update team_games set game_id = 10730 where game_id = 10754;
update game_files set game_id = 10730 where game_id = 10754;
delete from games where id = 10754;
update games set neutral_site = true where id= 10730;

update team_games set game_id = 10753 where game_id = 10735;
update game_files set game_id = 10753 where game_id = 10735;
delete from games where id = 10735;
update games set neutral_site = true where id= 10753;

update team_games set game_id = 10729 where game_id = 10752;
update game_files set game_id = 10729 where game_id = 10752;
delete from games where id = 10752;
update games set neutral_site = false where id= 10729;

update team_games set game_id = 10756 where game_id = 10751;
update game_files set game_id = 10756 where game_id = 107256;
delete from games where id = 10751;
update games set neutral_site = true where id= 10756;

update games set neutral_site = true where id= 10725;
update games set neutral_site = true where id= 10726;
update games set neutral_site = true where id= 10727;
update games set neutral_site = true where id= 10728;


update team_games set game_id = 10783 where game_id = 10807;
update game_files set game_id = 10783 where game_id = 10807;
delete from games where id = 10807;
update games set neutral_site = true where id= 10783;

update team_games set game_id = 10802 where game_id = 10758;
update game_files set game_id = 10802 where game_id = 10758;
delete from games where id = 10758;
update games set neutral_site = true where id= 10802;

update team_games set game_id = 10801 where game_id = 10780;
update game_files set game_id = 10801 where game_id = 10780;
delete from games where id = 10780;
update games set neutral_site = true where id= 10801;

update team_games set game_id = 10767 where game_id = 10804;
update game_files set game_id = 10767 where game_id = 10804;
delete from games where id = 10804;
update games set neutral_site = true where id= 10767;

update team_games set game_id = 10760 where game_id = 10803;
update game_files set game_id = 10760 where game_id = 10803;
delete from games where id = 10803;
update games set neutral_site = true where id= 10760;

update team_games set game_id = 10805 where game_id = 10796;
update game_files set game_id = 10805 where game_id = 10796;
delete from games where id = 10796;
update games set neutral_site = true where id= 10805;

update team_games set game_id = 10810 where game_id = 10808;
update game_files set game_id = 10810 where game_id = 10808;
delete from games where id = 10808;
update games set neutral_site = true where id= 10810;

update games set neutral_site = true where id= 10757;
update games set neutral_site = true where id= 10759;
update games set neutral_site = true where id= 10761;
update games set neutral_site = true where id= 10762;
update games set neutral_site = true where id= 10763;
update games set neutral_site = true where id= 10775;
update games set neutral_site = true where id= 10776;
update games set neutral_site = true where id= 10781;
update games set neutral_site = true where id= 10784;
update games set neutral_site = true where id= 10785;
update games set neutral_site = true where id= 10786;
update games set neutral_site = true where id= 10798;
update games set neutral_site = true where id= 10806;


update team_games set game_id = 10896 where game_id = 10895;
update game_files set game_id = 10896 where game_id = 10895;
delete from games where id = 10895;
update games set neutral_site = true where id= 10896;

update team_games set game_id = 10880 where game_id = 10891;
update game_files set game_id = 10880 where game_id = 10891;
delete from games where id = 10891;
update games set neutral_site = false where id= 10880;

update team_games set game_id = 10890 where game_id = 10827;
update game_files set game_id = 10890 where game_id = 10827;
delete from games where id = 10827;
update games set neutral_site = true where id= 10890;

update team_games set game_id = 10862 where game_id = 10893;
update game_files set game_id = 10862 where game_id = 10893;
delete from games where id = 10893;
update games set neutral_site = false where id= 10862;

update team_games set game_id = 10886 where game_id = 10811;
update game_files set game_id = 10886 where game_id = 10811;
delete from games where id = 10811;
update games set neutral_site = true where id= 10886;

update team_games set game_id = 10821 where game_id = 10888;
update game_files set game_id = 10821 where game_id = 10888;
delete from games where id = 10888;
update games set neutral_site = true where id= 10821;

update team_games set game_id = 10860 where game_id = 10887;
update game_files set game_id = 10860 where game_id = 10887;
delete from games where id = 10887;
update games set neutral_site = true where id= 10860;

update games set neutral_site = true where id= 10815;
update games set neutral_site = true where id= 10822;
update games set neutral_site = true where id= 10842;
update games set neutral_site = true where id= 10859;
update games set neutral_site = true where id= 10861;
update games set neutral_site = true where id= 10894;


update team_games set game_id = 10938 where game_id = 10912;
update game_files set game_id = 10938 where game_id = 10912;
delete from games where id = 10912;
update games set neutral_site = true where id= 10938;

update team_games set game_id = 10937 where game_id = 10909;
update game_files set game_id = 10937 where game_id = 10909;
delete from games where id = 10909;
update games set neutral_site = true where id= 10937;

update team_games set game_id = 10936 where game_id = 10923;
update game_files set game_id = 10936 where game_id = 10923;
delete from games where id = 10923;
update games set neutral_site = true where id= 10936;

update team_games set game_id = 10935 where game_id = 10919;
update game_files set game_id = 10935 where game_id = 10919;
delete from games where id = 10919;
update games set neutral_site = true where id= 10935;

update team_games set game_id = 10933 where game_id = 10916;
update game_files set game_id = 10933 where game_id = 10916;
delete from games where id = 10916;
update games set neutral_site = true where id= 10933;

update team_games set game_id = 10932 where game_id = 10898;
update game_files set game_id = 10932 where game_id = 10898;
delete from games where id = 10898;
update games set neutral_site = true where id= 10932;

update team_games set game_id = 10897 where game_id = 10914;
update game_files set game_id = 10897 where game_id = 10914;
delete from games where id = 10914;
update games set neutral_site = true where id= 10897;

update games set neutral_site = true where id= 10907;
update games set neutral_site = true where id= 10910;
update games set neutral_site = true where id= 10913;
update games set neutral_site = true where id= 10922;
update games set neutral_site = true where id= 10930;
update games set neutral_site = true where id= 10931;
update games set neutral_site = true where id= 10934;

update team_games set game_id = 10967 where game_id = 10946;
update game_files set game_id = 10967 where game_id = 10946;
delete from games where id = 10946;
update games set neutral_site = true where id= 10967;

update team_games set game_id = 10966 where game_id = 10953;
update game_files set game_id = 10966 where game_id = 10953;
delete from games where id = 10953;
update games set neutral_site = true where id= 10966;

update team_games set game_id = 10971 where game_id = 10952;
update game_files set game_id = 10971 where game_id = 10952;
delete from games where id = 10952;
update games set neutral_site = true where id= 10971;

update team_games set game_id = 10970 where game_id = 10951;
update game_files set game_id = 10970 where game_id = 10951;
delete from games where id = 10951;
update games set neutral_site = true where id= 10970;

update games set neutral_site = true where id= 10941;
update games set neutral_site = true where id= 10947;
update games set neutral_site = true where id= 10954;
update games set neutral_site = true where id= 10963;


update team_games set game_id = 11030 where game_id = 11036;
update game_files set game_id = 11030 where game_id = 11036;
delete from games where id = 11036;
update games set neutral_site = true where id= 11030;

update team_games set game_id = 11035 where game_id = 10996;
update game_files set game_id = 11035 where game_id = 10996;
delete from games where id = 10996;
update games set neutral_site = true where id= 11035;

update team_games set game_id = 11034 where game_id = 11014;
update game_files set game_id = 11034 where game_id = 11014;
delete from games where id = 11014;


update team_games set game_id = 11032 where game_id = 11003;
update game_files set game_id = 11032 where game_id = 11003;
delete from games where id = 11003;
update games set neutral_site = true where id= 11032;

update team_games set game_id = 11031 where game_id = 10999;
update game_files set game_id = 11031 where game_id = 10999;
delete from games where id = 10999;
update games set neutral_site = true where id= 11031;


update team_games set game_id = 11075 where game_id = 11053;
update game_files set game_id = 11075 where game_id = 11053;
delete from games where id = 11053;
update games set neutral_site = true where id= 11075;

update team_games set game_id = 11074 where game_id = 11057;
update game_files set game_id = 11074 where game_id = 11057;
delete from games where id = 11057;
update games set neutral_site = true where id= 11074;

update team_games set game_id = 11073 where game_id = 11056;
update game_files set game_id = 11073 where game_id = 11056;
delete from games where id = 11056;
update games set neutral_site = true where id= 11073;

update team_games set game_id = 11078 where game_id = 11077;
update game_files set game_id = 11078 where game_id = 11077;
delete from games where id = 11077;
update games set neutral_site = true where id= 11078;

update games set neutral_site = true where id= 11051;
update games set neutral_site = true where id= 11055;
update games set neutral_site = true where id= 11062;

update games set neutral_site=true where played_on='2007-11-22';
update games set neutral_site = false where id= 11085;


 11147 | 11129 | 2007-11-23
update team_games set game_id = 11078 where game_id = 11077;
update game_files set game_id = 11078 where game_id = 11077;
delete from games where id = 11077;
update games set neutral_site = true where id= 11078;

update team_games set game_id = 11147 where game_id = 11125;
update game_files set game_id = 11147 where game_id = 11125;
delete from games where id = 11125;
update games set neutral_site = true where id= 11147;

update team_games set game_id = 11106 where game_id = 11150;
update game_files set game_id = 11106 where game_id = 11150;
delete from games where id = 11150;
update games set neutral_site = true where id= 11106;

update team_games set game_id = 11124 where game_id = 11149;
update game_files set game_id = 11124 where game_id = 11149;
delete from games where id = 11149;
update games set neutral_site = true where id= 11124;

update team_games set game_id = 11146 where game_id = 11122;
update game_files set game_id = 11146 where game_id = 11122;
delete from games where id = 11122;
update games set neutral_site = true where id= 11146;

update team_games set game_id = 11144 where game_id = 11119;
update game_files set game_id = 11144 where game_id = 11119;
delete from games where id = 11119;
update games set neutral_site = true where id= 11144;

update team_games set game_id = 11140 where game_id = 11098;
update game_files set game_id = 11140 where game_id = 11098;
delete from games where id = 11098;
update games set neutral_site = true where id= 11140;

update team_games set game_id = 11143 where game_id = 11116;
update game_files set game_id = 11143 where game_id = 11116;
delete from games where id = 11116;
update games set neutral_site = true where id= 11143;

update team_games set game_id = 11137 where game_id = 11114;
update game_files set game_id = 11137 where game_id = 11114;
delete from games where id = 11114;
update games set neutral_site = true where id= 11137;

update team_games set game_id = 11148 where game_id = 11093;
update game_files set game_id = 11148 where game_id = 11093;
delete from games where id = 11093;
update games set neutral_site = true where id= 11148;

update team_games set game_id = 11091 where game_id = 11133;
update game_files set game_id = 11091 where game_id = 11133;
delete from games where id = 11133;
update games set neutral_site = true where id= 11091;

update team_games set game_id = 11131 where game_id = 11109;
update game_files set game_id = 11131 where game_id = 11109;
delete from games where id = 11109;
update games set neutral_site = true where id= 11131;

update team_games set game_id = 11130 where game_id = 11089;
update game_files set game_id = 11130 where game_id = 11089;
delete from games where id = 11089;
update games set neutral_site = true where id= 11130;

update team_games set game_id = 11128 where game_id = 11088;
update game_files set game_id = 11128 where game_id = 11088;
delete from games where id = 11088;
update games set neutral_site = true where id= 11128;

update team_games set game_id = 11120 where game_id = 11145;
update game_files set game_id = 11120 where game_id = 11145;
delete from games where id = 11145;
update games set neutral_site = true where id= 11120;

update team_games set game_id = 11117 where game_id = 11142;
update game_files set game_id = 11117 where game_id = 11142;
delete from games where id = 11142;
update games set neutral_site = true where id= 11117;

update team_games set game_id = 11099 where game_id = 11141;
update game_files set game_id = 11099 where game_id = 11141;
delete from games where id = 11141;
update games set neutral_site = true where id= 11099;

update team_games set game_id = 11096 where game_id = 11138;
update game_files set game_id = 11096 where game_id = 11138;
delete from games where id = 11138;
update games set neutral_site = true where id= 11096;

update team_games set game_id = 11113 where game_id = 11136;
update game_files set game_id = 11113 where game_id = 11136;
delete from games where id = 11136;
update games set neutral_site = true where id= 11113;

update team_games set game_id = 11094 where game_id = 11135;
update game_files set game_id = 11094 where game_id = 11135;
delete from games where id = 11135;
update games set neutral_site = true where id= 11094;

update team_games set game_id = 11111 where game_id = 11134;
update game_files set game_id = 11111 where game_id = 11134;
delete from games where id = 11134;
update games set neutral_site = true where id= 11111;

update team_games set game_id = 11110 where game_id = 11132;
update game_files set game_id = 11110 where game_id = 11132;
delete from games where id = 11132;
update games set neutral_site = true where id= 11110;

update team_games set game_id = 11151 where game_id = 11247;
update game_files set game_id = 11151 where game_id = 11247;
delete from games where id = 11247;
update games set neutral_site = true where id= 11151;

update team_games set game_id = 11152 where game_id = 11129;
update game_files set game_id = 11152 where game_id = 11129;
delete from games where id = 11129;
update games set neutral_site = false where id= 11152;

update games set neutral_site = true where id= 11092;
update games set neutral_site = true where id= 11103;
update games set neutral_site = true where id= 11104;
update games set neutral_site = true where id= 11108;
update games set neutral_site = true where id= 11115;
update games set neutral_site = true where id= 11127;

update team_games set game_id = 11260 where game_id = 11176;
update game_files set game_id = 11260 where game_id = 11176;
delete from games where id = 11176;
update games set neutral_site = true where id= 11260;

update team_games set game_id = 11258 where game_id = 11224;
update game_files set game_id = 11258 where game_id = 11224;
delete from games where id = 11224;
update games set neutral_site = true where id= 11258;

update team_games set game_id = 11222 where game_id = 11266;
update game_files set game_id = 11222 where game_id = 11266;
delete from games where id = 11266;
update games set neutral_site = true where id= 11222;

update team_games set game_id = 11254 where game_id = 11170;
update game_files set game_id = 11254 where game_id = 11170;
delete from games where id = 11170;
update games set neutral_site = true where id= 11254;

update team_games set game_id = 11253 where game_id = 11167;
update game_files set game_id = 11253 where game_id = 11167;
delete from games where id = 11167;
update games set neutral_site = true where id= 11253;

update team_games set game_id = 11250 where game_id = 11205;
update game_files set game_id = 11250 where game_id = 11205;
delete from games where id = 11205;
update games set neutral_site = true where id= 11250;

update team_games set game_id = 11245 where game_id = 11199;
update game_files set game_id = 11245 where game_id = 11199;
delete from games where id = 11199;
update games set neutral_site = true where id= 11245;

update team_games set game_id = 11243 where game_id = 11267;
update game_files set game_id = 11243 where game_id = 11267;
delete from games where id = 11267;
update games set neutral_site = true where id= 11243;

update team_games set game_id = 11190 where game_id = 11265;
update game_files set game_id = 11190 where game_id = 11265;
delete from games where id = 11265;
update games set neutral_site = true where id= 11190;

update team_games set game_id = 11181 where game_id = 11263;
update game_files set game_id = 11181 where game_id = 11263;
delete from games where id = 11263;
update games set neutral_site = true where id= 11181;
 11263 | 11246 | 2007-11-24
update team_games set game_id = 11152 where game_id = 11129;
update game_files set game_id = 11152 where game_id = 11129;
delete from games where id = 11129;
update games set neutral_site = true where id= 11152;

update team_games set game_id = 11180 where game_id = 11261;
update game_files set game_id = 11180 where game_id = 11261;
delete from games where id = 11261;
update games set neutral_site = true where id= 11180;

update team_games set game_id = 11175 where game_id = 11259;
update game_files set game_id = 11175 where game_id = 11259;
delete from games where id = 11259;
update games set neutral_site = true where id= 11175;

update team_games set game_id = 11174 where game_id = 11257;
update game_files set game_id = 11174 where game_id = 11257;
delete from games where id = 11257;
update games set neutral_site = true where id= 11174;

update team_games set game_id = 11221 where game_id = 11256;
update game_files set game_id = 11221 where game_id = 11256;
delete from games where id = 11256;

 11249 | 11198 | 2007-11-24
update team_games set game_id = 11152 where game_id = 11129;
update game_files set game_id = 11152 where game_id = 11129;
delete from games where id = 11129;
update games set neutral_site = true where id= 11152;

update team_games set game_id = 11156 where game_id = 11248;
update game_files set game_id = 11156 where game_id = 11248;
delete from games where id = 11248;
update games set neutral_site = true where id= 11156;

update team_games set game_id = 11246 where game_id = 11244;
update game_files set game_id = 11246 where game_id = 11244;
delete from games where id = 11244;
update games set neutral_site = true where id= 11246;

update team_games set game_id = 11247 where game_id = 11269;
update game_files set game_id = 11247 where game_id = 11269;
delete from games where id = 11247;
update games set neutral_site = true where id= 11269;

update team_games set game_id = 11127 where game_id = 11246;
update game_files set game_id = 11127 where game_id = 11246;
delete from games where id = 11246;
update games set neutral_site = true where id= 11127;


update team_games set game_id = 11296 where game_id = 13117;
update game_files set game_id = 11296 where game_id = 13117;
delete from games where id = 13117;
update games set neutral_site = true where id= 11296;

update team_games set game_id = 11296 where game_id = 11270;
update game_files set game_id = 11296 where game_id = 11270;
delete from games where id = 11270;
update games set neutral_site = true where id= 11296;

update team_games set game_id = 11151 where game_id = 11153;
update game_files set game_id = 11151 where game_id = 11153;
delete from games where id = 11153;
update games set neutral_site = true where id= 11151;

update team_games set game_id = 11152 where game_id = 11249;
update game_files set game_id = 11152 where game_id = 11249;
delete from games where id = 11249;

update team_games set game_id = 11152 where game_id = 11198;
update game_files set game_id = 11152 where game_id = 11198;
delete from games where id = 11198;

update team_games set game_id = 11251 where game_id = 11214;
update game_files set game_id = 11251 where game_id = 11214;
delete from games where id = 11214;

update team_games set game_id = 11268 where game_id = 13118;
update game_files set game_id = 11268 where game_id = 13118;
delete from games where id = 13118;

update games set neutral_site = true where id= 11168;
update games set neutral_site = true where id= 11191;
update games set neutral_site = true where id= 11193;
update games set neutral_site = true where id= 11268;







update team_games set game_id = 11302 where game_id = 11294;
update game_files set game_id = 11302 where game_id = 11294;
delete from games where id = 11294;
update games set neutral_site = true where id= 11302;

update team_games set game_id = 11301 where game_id = 11283;
update game_files set game_id = 11301 where game_id = 11283;
delete from games where id = 11283;
update games set neutral_site = true where id= 11301;

update team_games set game_id = 11300 where game_id = 11291;
update game_files set game_id = 11300 where game_id = 11291;
delete from games where id = 11291;
update games set neutral_site = true where id= 11300;

update team_games set game_id = 11299 where game_id = 11290;
update game_files set game_id = 11299 where game_id = 11290;
delete from games where id = 11290;
update games set neutral_site = true where id= 11299;

update team_games set game_id = 11297 where game_id = 11278;
update game_files set game_id = 11297 where game_id = 11278;
delete from games where id = 11278;
update games set neutral_site = true where id= 11297;

update team_games set game_id = 11295 where game_id = 11284;
update game_files set game_id = 11295 where game_id = 11284;
delete from games where id = 11284;
update games set neutral_site = false where id= 11295;

update games set neutral_site = true where id= 11286;
update games set neutral_site = true where id= 11289;

update team_games set game_id = 11472 where game_id = 11463;
update game_files set game_id = 11472 where game_id = 11463;
delete from games where id = 11463;
update games set neutral_site = true where id= 11472;

update team_games set game_id = 11471 where game_id = 11454;
update game_files set game_id = 11471 where game_id = 11454;
delete from games where id = 11454;
update games set neutral_site = true where id= 11471;

update games set neutral_site = true where id= 11464;



update team_games set game_id = 11593 where game_id = 11569;
update game_files set game_id = 11593 where game_id = 11569;
delete from games where id = 11569;
update games set neutral_site = true where id= 11593;

update team_games set game_id = 11592 where game_id = 11560;
update game_files set game_id = 11592 where game_id = 11560;
delete from games where id = 11560;
update games set neutral_site = true where id= 11592;

update team_games set game_id = 11591 where game_id = 11500;
update game_files set game_id = 11591 where game_id = 11500;
delete from games where id = 11500;
update games set neutral_site = true where id= 11591;

update team_games set game_id = 11587 where game_id = 11474;
update game_files set game_id = 11587 where game_id = 11474;
delete from games where id = 11474;
update games set neutral_site = true where id= 11587;

update games set neutral_site = true where id= 11526;

update team_games set game_id = 11610 where game_id = 11599;
update game_files set game_id = 11610 where game_id = 11599;
delete from games where id = 11599;

update games set neutral_site = true where id= 11642;
update games set neutral_site = true where id= 11729;

update team_games set game_id = 11739 where game_id = 11751;
update game_files set game_id = 11739 where game_id = 11751;
delete from games where id = 11751;
update games set neutral_site = true where id= 11739;

update team_games set game_id = 11850 where game_id = 11821;
update game_files set game_id = 11850 where game_id = 11821;
delete from games where id = 11821;
update games set neutral_site = true where id= 11850;

update games set neutral_site = true where id= 11764;
update games set neutral_site = true where id= 11836;

update team_games set game_id = 11999 where game_id = 11978;
update game_files set game_id = 11999 where game_id = 11978;
delete from games where id = 11978;
update games set neutral_site = false where id= 11999;

update team_games set game_id = 11956 where game_id = 12000;
update game_files set game_id = 11956 where game_id = 12000;
delete from games where id = 12000;
update games set neutral_site = true where id= 11956;

update games set neutral_site = true where id= 11965;
update games set neutral_site = true where id= 11967;


update team_games set game_id = 12077 where game_id = 12050;
update game_files set game_id = 12077 where game_id = 12050;
delete from games where id = 12050;
update games set neutral_site = true where id= 12077;

update games set neutral_site = true where id= 12060;

update team_games set game_id = 12131 where game_id = 12081;
update game_files set game_id = 12131 where game_id = 12081;
delete from games where id = 12081;
update games set neutral_site = true where id= 12131;

update games set neutral_site = true where id= 12127;
update games set neutral_site = true where id= 12129;
update team_games set game_id = 12132 where game_id = 12133;
update game_files set game_id = 12132 where game_id = 12133;
delete from games where id = 12133;

update team_games set game_id = 12164 where game_id = 12165;
update game_files set game_id = 12164 where game_id = 12165;
delete from games where id = 12165;
update games set neutral_site = true where id= 12164;

update team_games set game_id = 12162 where game_id = 12152;
update game_files set game_id = 12162 where game_id = 12152;
delete from games where id = 12152;
update games set neutral_site = true where id= 12162;

update games set neutral_site = true where id= 12134;
update games set neutral_site = true where id= 12136;
update games set neutral_site = true where id= 12138;
update games set neutral_site = true where id= 12151;

update team_games set game_id = 13399 where game_id = 13400;
update game_files set game_id = 13399 where game_id = 13400;
delete from games where id = 13400;
