create or replace view vw_aliases(alias, email, enabled) as
SELECT (a.alias::text || '@'::text) || d.name::text AS alias,
       a.email,
       d.enabled AND a.enabled                      AS enabled
FROM aliases a
         JOIN domains d ON d.id = a.domain_id;

alter table vw_aliases
    owner to mailuser;

create or replace view vw_recipient_bccs(source_email_address, receiver_email_address, enabled) as
SELECT (a.username::text || '@'::text) || d.name::text AS source_email_address,
       r.receiver_email_address,
       r.enabled
FROM recipient_bccs r
         JOIN accounts a ON a.id = r.account_id
         JOIN domains d ON d.id = a.domain_id;

alter table vw_recipient_bccs
    owner to mailuser;

create or replace view vw_sender_bccs(source_email_address, receiver_email_address, enabled) as
SELECT (a.username::text || '@'::text) || d.name::text AS source_email_address,
       f.receiver_email_address,
       f.enabled
FROM accounts a
         JOIN domains d ON a.domain_id = d.id
         JOIN sender_bccs f ON f.account_id = a.id;

alter table vw_sender_bccs
    owner to mailuser;

create or replace view vw_user_logins(domain_id, account_id, login, password, enabled) as
SELECT d.id                                            AS domain_id,
       a.id                                            AS account_id,
       (a.username::text || '@'::text) || d.name::text AS login,
       a.password,
       d.enabled AND a.enabled                         AS enabled
FROM accounts a
         JOIN domains d ON d.id = a.domain_id;

alter table vw_user_logins
    owner to mailuser;

