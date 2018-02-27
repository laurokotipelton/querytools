--deleta o registro inicial de migração que estava nas lojas erradas

delete from estoque_movimentacao 
where mov_id in (2756022,2923101,2771724,2933187,2792211,2945529,2945532,2792214,2805744,2954241);

delete from estoque_movimentacao 
where mov_id in (2756023,2923102,2771725,2933188,2792212,2945530,2792215,2945533,2805745,2954242);

delete from estoque_movimentacao 
where mov_id in (
    select mov_id 
        from estoque_movimentacao m 
        inner join produto p on m.procod = p.procod 
    where mov_historico = 'MIGRACAO' and loj_codigo = 2 and promix = 'A');

delete from estoque_movimentacao 
where mov_id in (
    select mov_id 
        from estoque_movimentacao m 
        inner join produto p on m.procod = p.procod 
    where mov_historico = 'MIGRACAO' and loj_codigo = 3 and promix = 'A');

--deleta os registros duplicados

delete from estoque_movimentacao where mov_id in (
	select min(mov_id) from estoque_movimentacao where procod in (
		(select m.procod from estoque_movimentacao m inner join produto p on m.procod = p.procod 
			where mov_historico = 'MIGRACAO' 
            and loj_codigo = 1 and promix = 'A' 
		group by m.procod having count(m.procod) > 1 order by m.procod) 
	)group by procod having count(procod) > 1)
;

--atualiza o estoque inicial conforme mix

update estoque_movimentacao set loj_codigo = 2 where procod in ( 
    select m.procod 
        from estoque_movimentacao m
    inner join produto p on m.procod = p.procod
    where mov_historico = 'MIGRACAO' and loj_codigo = 1 and promix = 'B' order by procod)
;

update estoque_movimentacao set loj_codigo = 3 where procod in ( 
    select m.procod 
        from estoque_movimentacao m
    inner join produto p on m.procod = p.procod
    where mov_historico = 'MIGRACAO' and loj_codigo = 1 and promix = 'C' order by procod)
;