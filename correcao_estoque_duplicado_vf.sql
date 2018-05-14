BEGIN;

SELECT procod,loj_codigo,loc_codigo,mov_quantidade,mov_data_registro,mov_historico,itn_id
  FROM estoque_movimentacao em
 WHERE em.mov_tipo = 'NOTA_FISCAL'
   AND em.mov_historico LIKE '% 12519 %'
 ORDER BY procod, mov_data_registro
;

DELETE
  FROM ESTOQUE_MOVIMENTACAO
 WHERE MOV_TIPO = 'NOTA_FISCAL'
   AND MOV_ID IN (SELECT MAX(MOV_ID)
                    FROM ESTOQUE_MOVIMENTACAO EM
                   INNER JOIN ITEM_NOTA_FISCAL INF ON (INF.ITN_ID = EM.ITN_ID)
                   WHERE INF.NTA_CODIGO = (select nta_codigo from nota_fiscal where nta_numero = '12519')
                     AND EM.MOV_TIPO = 'NOTA_FISCAL'
                   GROUP BY EM.PROCOD, EM.LOJ_CODIGO, EM.LOC_CODIGO, EM.MOV_QUANTIDADE, EM.ITN_ID)
;