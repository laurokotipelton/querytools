INSERT INTO FILA_SINCRONIZACAO_PANAMA (ID, IDENTIFICADOR, PRIORIDADE, BODY, OPERACAO)
	(SELECT NEXTVAL('SQ_FILA_SINCRONIZACAO_PANAMA'), 'VENDA', 2, TO_JSON(VENDAS), 'ATUALIZACAO'
	 FROM (SELECT T.TRNSEQ::TEXT||'-'||T.CXANUM::TEXT||'-'||T.LOJCOD::TEXT||'-'||TO_CHAR(T.TRNDAT, 'yyyy-MM-dd') AS "id",
				   T.TRNSEQ::TEXT AS "sequencial",
				   T.CXANUM::TEXT AS "numeroCaixa",
				   T.LOJCOD::TEXT AS "lojaId",
				   T.TRNDAT AS "data",
				   COALESCE(T.TRNHORFIN, COALESCE(T.TRNHORINI, COALESCE(T.TRNDATVEN, T.TRNDAT))) AS "dataHoraVenda",
				   FUN.FUN_CODIGO::TEXT AS "funcionarioId",
				   C.CLI_CODIGO::TEXT AS "clienteId",
				   true AS "efetiva",
				   T.TRNTIPPRC::TEXT AS "tipoPreco",
				   T.TRNTDCCOD::TEXT AS "tipoDesconto",
				   T.TRNVLR AS "valor",
				   T.TRNACR AS "acrescimo",
				   T.TRNDCN AS "desconto",
				   T.TRNVLRSER AS "servico",
				   COALESCE(T.TRNQTDITEVDA, (SELECT COUNT(IV.ID) 
											 FROM ITEM_VENDA IV 
											 WHERE T.TRNSEQ = IV.TRNSEQ 
												   AND T.LOJCOD = IV.LOJCOD 
												   AND T.TRNDAT = IV.TRNDAT 
												   AND T.CXANUM = IV.CXANUM 
												   AND IV.ITVTIP = '1' 
												   AND IV.ITVVLRUNI > 0)
	                      ) AS "quantidadeItens",
				   COALESCE(T.TRNQTDITECAN, (SELECT COUNT(IV.ID) 
											 FROM ITEM_VENDA IV 
											 WHERE T.TRNSEQ = IV.TRNSEQ 
												   AND T.LOJCOD = IV.LOJCOD 
												   AND T.TRNDAT = IV.TRNDAT 
												   AND T.CXANUM = IV.CXANUM 
												   AND IV.ITVTIP = '2')
	                      ) AS "quantidadeItensCancelados",
				   COALESCE(T.TRNVLRITECAN, (SELECT SUM(IV.ITVVLRTOT) 
											 FROM ITEM_VENDA IV 
											 WHERE T.TRNSEQ = IV.TRNSEQ 
												   AND T.LOJCOD = IV.LOJCOD 
												   AND T.TRNDAT = IV.TRNDAT 
												   AND T.CXANUM = IV.CXANUM 
												   AND IV.ITVTIP = '2')
	                      ) AS "valorItensCancelados",
				   (SELECT JSON_AGG(ITENS) 
					FROM (SELECT IV.PROCOD::TEXT AS "produtoId", 
	  							 IV.FUNCOD::TEXT AS "funcionarioId",
	  							 true AS "efetivo",
	  							 IV.ITVQTDVDA AS "quantidade",
	  							 IV.ITVVLRUNI AS "valorUnitario",
	                            IV.ITVVLRTOT AS "valorTotal",
	                            IV.ITVVLRACR AS "acrescimo",
	                            IV.ITVVLRDCN AS "desconto",
	                            COALESCE(IV.ITVPRCVDA, IV.ITVVLRTOT/IV.ITVQTDVDA) AS "preco",
	                            IV.ITVVLRSER AS "servico",
	                            IV.ITVTIPPRC::TEXT AS "tipoPreco"
	                  	  FROM ITEM_VENDA IV 
	                  	  WHERE T.TRNSEQ = IV.TRNSEQ 
	                           AND T.LOJCOD = IV.LOJCOD 
	                           AND T.TRNDAT = IV.TRNDAT 
	                           AND T.CXANUM = IV.CXANUM 
	                           AND IV.ITVTIP = '1' 
	                           AND IV.ITVVLRUNI > 0) ITENS) 
	              AS "itens",
				   (SELECT JSON_AGG(FIN) 
					FROM (SELECT F.FZCSEQ::TEXT AS "sequencial", 
							     F.FZDCOD::TEXT AS "formaPagamentoId", 
								 F.FZCVLR - COALESCE(F.FZCCTRVAL, 0) AS "valor" 
						  FROM FINALIZACAO F 
						  WHERE F.TRNDAT = T.TRNDAT 
								AND F.LOJCOD = T.LOJCOD 
								AND F.TRNSEQ = T.TRNSEQ 
								AND F.CXANUM = T.CXANUM) FIN) 
	              AS "pagamentos"
	       FROM TRANSACAO T
	       JOIN ITEM_VENDA I ON ( T.TRNSEQ = I.TRNSEQ 
							       AND T.LOJCOD = I.LOJCOD 
							       AND T.TRNDAT = I.TRNDAT 
							       AND T.CXANUM = I.CXANUM)
	       JOIN FINALIZACAO F ON ( T.TRNSEQ = F.TRNSEQ 
							        AND T.LOJCOD = F.LOJCOD 
							        AND T.TRNDAT = F.TRNDAT 
							        AND T.CXANUM = F.CXANUM ) 
	       LEFT JOIN PESSOA_CLIENTE C ON (T.CLICOD = C.CLI_CODIGO) 
	       LEFT JOIN PESSOA_FUNCIONARIO FUN ON (T.FUNCOD = FUN.FUN_CODIGO) 
			WHERE T.TRNDAT BETWEEN '2017-08-01' AND '2017-08-01'
				  AND T.TRNTIP = '1'
				  AND I.ITVTIP = '1'
	              AND I.ITVVLRUNI > 0
			GROUP BY T.TRNSEQ, T.LOJCOD, T.TRNDAT, T.CXANUM, C.CLI_CODIGO, FUN.FUN_CODIGO)
	VENDAS);