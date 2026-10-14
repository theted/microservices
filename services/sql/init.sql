-- The database is the microservice: PostgREST turns this function into
-- GET /rpc/collatz_step?n=27.
create schema api;

create function api.collatz_step(n bigint) returns bigint
  language sql immutable strict
  return case when n < 1 then null
              when n % 2 = 0 then n / 2
              else 3 * n + 1 end;

create role web_anon nologin;
grant usage on schema api to web_anon;
grant execute on function api.collatz_step(bigint) to web_anon;

create role authenticator noinherit login password 'hailstone';
grant web_anon to authenticator;
