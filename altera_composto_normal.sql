UPDATE PRODUTO SET PROCOMP = 'N' WHERE PROCOD IN (970,3025,3308,3452,4388,41980,89029,259040,269117,356145,359542);
delete from componentes_composicao where cc_comp_id in (select comp_id from composicao where comp_procod in (select procod from produto where procomp not in ('K','C')));
delete from composicao where comp_procod in (select procod from produto where procomp not in ('K','C'));