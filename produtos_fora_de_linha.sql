updadte produto set proforlin = 'S', prodatforlin = '2018-02-07',prod_bloqueado_compra = true where procod in (
select procod from produto where procod not in (select distinct(p.procod) from produto p inner join estoque_movimentacao e 
on p.procod = e.procod where mov_data between '2017-07-31' and '2018-01-26' and	mov_tipo = 'VENDA'));