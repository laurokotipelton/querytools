DELETE
  FROM ESTATISTICA_PRODUTO_COMPRA
 WHERE EPC_DATA_HORA_COMPRA IS NULL
   AND EPC_PROCOD IN (SELECT P.PROCOD
                        FROM PRODUTO P
                        LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                       WHERE IV.PROCOD IS NULL
                         AND INF.PROCOD IS NULL
                         AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ESTATISTICA_PRODUTO_VENDA
 WHERE EPV_DATA_HORA_VENDA IS NULL
   AND EPV_PROCOD IN (SELECT P.PROCOD
                        FROM PRODUTO P
                        LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                       WHERE IV.PROCOD IS NULL
                         AND INF.PROCOD IS NULL
                         AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ESTATISTICA_PRODUTO_MOVIMENTACAO
 WHERE EPM_PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND EPM_PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND EPM_PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND EPM_PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND EPM_PROCOD IN (SELECT P.PROCOD
                        FROM PRODUTO P
                        LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                        LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                       WHERE IV.PROCOD IS NULL
                         AND INF.PROCOD IS NULL
                         AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ESTOQUE_DIA
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ESTOQUE_MOVIMENTACAO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ESTOQUE_RESUMO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM PRECO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM PRODUTO_FAMILIA
 WHERE CODIGO_PRODUTO NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND CODIGO_PRODUTO IN (SELECT P.PROCOD
                            FROM PRODUTO P
                            LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                            LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                            LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                           WHERE IV.PROCOD IS NULL
                             AND INF.PROCOD IS NULL
                             AND IPC.PROCOD IS NULL)
;

DELETE
  FROM COMPONENTES_COMPOSICAO
 WHERE CC_COMP_ID IN (SELECT COMP_ID
                        FROM COMPOSICAO
                       WHERE COMP_PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
                         AND COMP_PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
                         AND COMP_PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
                         AND COMP_PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
			 AND COMP_PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
                         AND COMP_PROCOD IN (SELECT P.PROCOD
                                               FROM PRODUTO P
                                               LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                                               LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                                               LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                                              WHERE IV.PROCOD IS NULL
                                                AND INF.PROCOD IS NULL
                                                AND IPC.PROCOD IS NULL))
;

DELETE
  FROM COMPONENTES_COMPOSICAO
 WHERE CC_PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND CC_PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND CC_PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND CC_PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND CC_PROCOD IN (SELECT P.PROCOD
                       FROM PRODUTO P
                       LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                       LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                       LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                      WHERE IV.PROCOD IS NULL
                        AND INF.PROCOD IS NULL
                        AND IPC.PROCOD IS NULL)
;

DELETE
  FROM COMPOSICAO
 WHERE COMP_PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND COMP_PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND COMP_PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND COMP_PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND COMP_PROCOD IN (SELECT P.PROCOD
                       FROM PRODUTO P
                       LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                       LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                       LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                      WHERE IV.PROCOD IS NULL
                        AND INF.PROCOD IS NULL
                        AND IPC.PROCOD IS NULL)
;

DELETE
  FROM CUSTO_DIA
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM MOVIMENTACAO_DE_CUSTO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM IMPOSTOS_FEDERAIS_PRODUTO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM PRODUTOAUX
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ASSISTENTE_COMPRA_ITEM
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM ASSISTENTE_COMPRA_PRODUTO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;

DELETE
  FROM RENDIMENTO_PRODUTO
 WHERE CODIGO_PRODUTO NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND CODIGO_PRODUTO NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND CODIGO_PRODUTO IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL)
;


DELETE
  FROM PRODUTO_FORNECEDOR
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL) 
;

DELETE
  FROM PRODUTO
 WHERE PROCOD NOT IN (SELECT EPC_PROCOD FROM ESTATISTICA_PRODUTO_COMPRA GROUP BY EPC_PROCOD)
   AND PROCOD NOT IN (SELECT EPV_PROCOD FROM ESTATISTICA_PRODUTO_VENDA GROUP BY EPV_PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_TRANSFERENCIA GROUP BY PROCOD)
   AND PROCOD NOT IN (SELECT PROCOD FROM ITEM_AJUSTE_ESTOQUE GROUP BY PROCOD)
   AND PROCOD IN (SELECT P.PROCOD
                    FROM PRODUTO P
                    LEFT JOIN ITEM_VENDA IV ON (IV.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_NOTA_FISCAL INF ON (INF.PROCOD = P.PROCOD)
                    LEFT JOIN ITEM_PEDIDO_COMPRA IPC ON (IPC.PROCOD = P.PROCOD)
                   WHERE IV.PROCOD IS NULL
                     AND INF.PROCOD IS NULL
                     AND IPC.PROCOD IS NULL) 
;