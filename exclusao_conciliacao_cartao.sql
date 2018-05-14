CREATE TABLE public.exclusao_recebimento_cartao AS
SELECT m.ttlr_id, r.rec_id 
  FROM movimentacao_titulo_receber m
  JOIN titulo_a_receber t ON m.ttlr_id = t.ttlr_id
  JOIN conta_a_receber c ON t.ctr_id = c.ctr_id
  JOIN recebimento_cartao r ON c.rec_id = r.rec_id
 WHERE c.ctr_data_emissao BETWEEN '2018-03-14' AND '2018-04-13'
   AND r.bc_codigo = '20032' 
   AND r.rec_modalidade = 'DEBITO' ;
DELETE FROM movimentacao_titulo_receber WHERE ttlr_id IN (SELECT ttlr_id FROM exclusao_recebimento_cartao) ;
DELETE FROM titulo_a_receber WHERE ttlr_id IN (SELECT ttlr_id FROM exclusao_recebimento_cartao) ;
DELETE FROM conta_a_receber WHERE rec_id IN (SELECT rec_id FROM exclusao_recebimento_cartao) ;
DELETE FROM recebimento_cartao WHERE rec_id IN (SELECT rec_id FROM exclusao_recebimento_cartao) ;
DROP TABLE exclusao_recebimento_cartao ;