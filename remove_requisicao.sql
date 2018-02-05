delete from estoque_movimentacao where mov_tipo = 'REQUISICAO' and itt_id in (select itt_id from item_transferencia where tfl_codigo = 828);
delete from item_transferencia where tfl_codigo = 828;
delete from transferencia_de_local where tfl_codigo = 828;