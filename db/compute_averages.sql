drop table team_averages;
select tg.team_id as id,
       tg.team_id,
       count(*) as games,
       avg(tg.fgm) as fgm,
       avg(tg.fga) as fga,
       cast(sum(tg.fgm) as double precision)/cast(sum(tg.fga) as double precision) as fgp,
        avg(tg.tpm) as tpm,
        avg(tg.tpa) as tpa,
        cast(sum(tg.tpm) as double precision)/cast(sum(tg.tpa) as double precision) as tpp,
        avg(tg.ftm) as ftm,
        avg(tg.fta) as fta,
        cast(sum(tg.ftm) as double precision)/cast(sum(tg.fta) as double precision) as ftp,
        (cast(sum(tg.fgm) as double precision) + 0.5 * cast(sum(tg.tpm) as double precision))/cast(sum(tg.fga) as double precision) as eff_fgp,
        avg(tg.offense_rebound) as  offense_rebound,
        avg(tg.total_rebound) as total_rebound,
        avg(tg.assist) as assist,
        avg(tg.steal) as steal,
        avg(tg.block) as block,
        avg(tg.turnover) as turnover,
        avg(tg.foul) as foul,
        avg(tg.half1_point) as half1_point,
        avg(tg.half2_point) as half2_point,
        avg(tg.total_point) as total_point,
        cast(sum(tg.turnover) as double precision) as total_to,
        cast(sum(tg.total_point) as double precision) as ppp,
        cast(sum(tg.ftm) as double precision) / cast(sum(tg.fga) as double precision) as get_ft
  into team_averages
  from team_games tg, games g
 where tg.type = 'MasterTeamGame'
   and g.played_on > '2008-11-1'
   and g.id = tg.game_id
 group by tg.team_id;

alter table team_averages add column orp double precision;
alter table team_averages add column to_rate double precision;
alter table team_averages add column poss double precision;

select  tg1.team_id,
        cast(sum(tg1.offense_rebound) as double precision) / (cast(sum(tg1.offense_rebound) as double precision) + cast(sum(tg2.total_rebound) as double precision) - cast(sum(tg2.offense_rebound) as double precision)) as orp,
        cast(sum(tg1.fga) as double precision) - (cast(sum(tg1.offense_rebound) as double precision) / (cast(sum(tg1.offense_rebound) as double precision) + cast(sum(tg2.total_rebound) as double precision) - cast(sum(tg2.offense_rebound) as double precision))) * (cast(sum(tg1.fga) as double precision) - cast(sum(tg1.fgm) as double precision)) * 1.07 + cast(sum(tg1.turnover) as double precision) + 0.4 * cast(sum(tg1.fta) as double precision) as poss
  into temporary orp_table
  from team_games tg1,
       team_games tg2,
       games g
 where tg1.game_id = g.id
   and tg2.game_id = g.id
   and g.played_on > '2008-11-1'
   and tg1.id != tg2.id
   and tg1.type = 'MasterTeamGame'
   and tg1.type = tg2.type
 group by tg1.team_id;

update team_averages
   set orp = orp.orp,
       poss = orp.poss
  from orp_table orp
 where id = orp.team_id;

update team_averages
   set to_rate =  total_to / poss,
       ppp = ppp/poss;

update team_averages
   set poss = poss / games;

drop table team_foe_averages;
select tg1.team_id as id,
       tg1.team_id,
       count(*) as games,
       avg(tg2.fgm) as fgm,
       avg(tg2.fga) as fga,
       cast(sum(tg2.fgm) as double precision)/cast(sum(tg2.fga) as double precision) as fgp,
        avg(tg2.tpm) as tpm,
        avg(tg2.tpa) as tpa,
        cast(sum(tg2.tpm) as double precision)/cast(sum(tg2.tpa) as double precision) as tpp,
        avg(tg2.ftm) as ftm,
        avg(tg2.fta) as fta,
        cast(sum(tg2.ftm) as double precision)/cast(sum(tg2.fta) as double precision) as ftp,
        (cast(sum(tg2.fgm) as double precision) + 0.5 * cast(sum(tg2.tpm) as double precision))/cast(sum(tg2.fga) as double precision) as eff_fgp,
        avg(tg2.offense_rebound) as  offense_rebound,
        cast(sum(tg2.offense_rebound) as double precision) / (cast(sum(tg2.offense_rebound) as double precision) + cast(sum(tg1.total_rebound) as double precision) - cast(sum(tg1.offense_rebound) as double precision)) as orp,
        cast(sum(tg2.fga) as double precision) - (cast(sum(tg2.offense_rebound) as double precision) / (cast(sum(tg2.offense_rebound) as double precision) + cast(sum(tg1.total_rebound) as double precision) - cast(sum(tg1.offense_rebound) as double precision))) * (cast(sum(tg2.fga) as double precision) - cast(sum(tg2.fgm) as double precision)) * 1.07 + cast(sum(tg2.turnover) as double precision) + 0.4 * cast(sum(tg2.fta) as double precision) as poss,
        cast(sum(tg2.turnover) as double precision) as total_to,
        avg(tg2.total_rebound) as total_rebound,
        avg(tg2.assist) as assist,
        avg(tg2.steal) as steal,
        avg(tg2.block) as block,
        avg(tg2.turnover) as turnover,
        avg(tg2.foul) as foul,
        avg(tg2.half1_point) as half1_point,
        avg(tg2.half2_point) as half2_point,
        avg(tg2.total_point) as total_point,
        cast(sum(tg2.total_point) as double precision) as ppp,
        cast(sum(tg2.fta) as double precision) / cast(sum(tg2.fga) as double precision) as get_ft
  into team_foe_averages
  from games g, team_games tg1, team_games tg2
 where tg1.game_id = g.id
   and tg2.game_id = g.id
   and g.played_on > '2008-11-1'
   and tg1.id != tg2.id
   and tg1.type = 'MasterTeamGame'
   and tg1.type = tg2.type
 group by tg1.team_id;

alter table team_foe_averages add column to_rate double precision;

update team_foe_averages
   set to_rate = total_to/poss,
       ppp = ppp/poss;

update team_foe_averages
   set poss = poss/games;

drop table player_averages;
select pg.player_id as id,
       pg.player_id,
       count(*) as games_played,
       avg(pg.fgm) as fgm,
       avg(pg.fga) as fga,
       cast(sum(pg.fgm) as double precision)/(cast(sum(pg.fga) as double precision) + .00000000001) as fgp,
        avg(pg.tpm) as tpm,
        avg(pg.tpa) as tpa,
        cast(sum(pg.tpm) as double precision)/(cast(sum(pg.tpa) as double precision) + .00000000001) as tpp,
        avg(pg.ftm) as ftm,
        avg(pg.fta) as fta,
        cast(sum(pg.ftm) as double precision)/(cast(sum(pg.fta) as double precision) + .00000000001) as ftp,
        avg(pg.offense_rebound) as  offense_rebound,
        avg(pg.total_rebound) as total_rebound,
        avg(pg.assist) as assist,
        avg(pg.steal) as steal,
        avg(pg.block) as block,
        avg(pg.turnover) as turnover,
        avg(pg.foul) as foul,
        avg(pg.total_point) as total_point
  into player_averages
  from player_games pg,
       team_games tg,
       games g
 where pg.type = 'MasterPlayerGame'
   and tg.type = 'MasterTeamGame'
   and pg.team_game_id = tg.id
   and tg.game_id = g.id
   and g.played_on > '2008-11-1'
 group by player_id;


insert into player_averages
select id, id, 0,
       0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
  from players
 where id not in (select id from player_averages);
