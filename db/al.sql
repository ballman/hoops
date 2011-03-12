update teams set in_64 = 'f';
select * from players where id = 18780;

update players set first_name = 'Stewart', last_name = 'Mitchell', suffix_name= null where id= 17329;
-- remove suffix from bs names
update players 
   set fox_bs_name = substring(first_name from 1 for 1) || ' ' || last_name,
       sn_bs_name = first_name || ' ' || last_name || ' ' || suffix_name,
       yahoo_bs_name = substring(first_name from 1 for 1) || '. ' || last_name
  where id = 18722;

update players set sn_bs_name = 'Trent Wiedeman' where id = 18207;

update players set fox_bs_name = 'T Adebamowo' where id = 16952;
update players set yahoo_bs_name = 'D.J. Newbill' where id = 17564;

select * from players where first_name like '%' and last_name like 'Ghantous%';
select * from teams where id = 210;
select id, fox_code from teams where name like '%Davis%';
update teams set fox_code= 'UC Davis' where id = 331;

select * from rosters where player_id = 15111;

insert into rosters (year, team_id, player_id) values (2010, 64, 15111);

update players set suffix_name = 'II' where id = 18706;

update player_games set player_name = replace(player_name, ' ', '') where player_name like '% %';


--    Merge two games
create temporary table game_swap (
   old_id int not null,
   new_id int not null
);

truncate table game_swap;
insert into game_swap values (28575, 28548);

update team_games set game_id = gs.new_id from game_swap gs where gs.old_id = team_games.game_id;
update game_files set game_id = gs.new_id from game_swap gs where gs.old_id = game_files.game_id;
delete from games where id in (select old_id from game_swap);
update games set neutral_site = 't' where id in (select new_id from game_swap);

-- delete game
create temp table delete_games (
 id int
);

truncate table delete_games;
insert into delete_games values 

delete from player_games where team_game_id in (select id from team_games where game_id  in (select id from delete_games));
delete from team_games where game_id in (select id from delete_games);
delete from game_files where game_id in (select id from delete_games);
delete from games where id in (select id from delete_games);


select max(id) from player_games;

delete from player_games where id =  2201747;

delete from game_files where game_date = '2011-3-5' and game_id is null and type = 'YahooGameFile';

update games 
   set neutral_site = 't'
 where id in (29074);
-- where played_on = '2010-12-24'; 15


select g1.id, g2.id, g2.played_on
  from games g1, games g2
 where g1.home_team_id = g2.home_team_id
   and g1.away_team_id = g2.away_team_id
   and g1.played_on = g2.played_on + 1
   order by g2.played_on;

select g1.id, g2.id, g2.played_on
  from games g1, games g2
 where g1.home_team_id = g2.away_team_id
   and g1.away_team_id = g2.home_team_id
   and g1.played_on = g2.played_on + 1
   order by g2.played_on;