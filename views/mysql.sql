create or replace definer = mailuser@localhost view vw_aliases as
select concat(`a`.`alias`, '@', `d`.`name`) AS `alias`,
       `a`.`email`                          AS `email`,
       (`d`.`enabled` & `a`.`enabled`)      AS `enabled`
from (`servermail`.`aliases` `a`
         join `servermail`.`domains` `d` on ((`d`.`id` = `a`.`domain_id`)));

create or replace definer = mailuser@localhost view vw_recipient_bccs as
select concat(`a`.`username`, '@', `d`.`name`) AS `source_email_address`,
       `r`.`receiver_email_address`            AS `receiver_email_address`,
       `r`.`enabled`                           AS `enabled`
from ((`servermail`.`recipient_bccs` `r` join `servermail`.`accounts` `a` on ((`a`.`id` = `r`.`account_id`)))
         join `servermail`.`domains` `d` on ((`d`.`id` = `a`.`domain_id`)));

create or replace definer = mailuser@localhost view vw_sender_bccs as
select concat(`a`.`username`, '@', `d`.`name`) AS `source_email_address`,
       `f`.`receiver_email_address`            AS `receiver_email_address`,
       `f`.`enabled`                           AS `enabled`
from ((`servermail`.`accounts` `a` join `servermail`.`domains` `d` on ((`a`.`domain_id` = `d`.`id`)))
         join `servermail`.`sender_bccs` `f` on ((`f`.`account_id` = `a`.`id`)));

create or replace definer = mailuser@localhost view vw_user_logins as
select `d`.`id`                                AS `domain_id`,
       `a`.`id`                                AS `account_id`,
       concat(`a`.`username`, '@', `d`.`name`) AS `login`,
       `a`.`password`                          AS `password`,
       (`d`.`enabled` & `a`.`enabled`)         AS `enabled`
from (`servermail`.`accounts` `a`
         join `servermail`.`domains` `d` on ((`d`.`id` = `a`.`domain_id`)));

