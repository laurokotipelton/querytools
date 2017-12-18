SELECT 'CAIXA: ' || CXANUM || ' DIA: ' || TO_CHAR(TRNDAT, 'DD/MM/YYYY') || ' OBS: ' || OBSERVACAO
  FROM CAIXA_GERAL
 WHERE CXGID IN (735)
 ORDER BY TRNDAT
;

-- Com a consulta acima deve-se pegar a observação do caixa que será reaberto e gardar para ser informado quando o caixa for fechado.

DELETE
  FROM LANCAMENTO_CONTA_CORRENTE
 WHERE LCC_DOCUMENTO IN (SELECT 'MOVCX' || CXANUM || 'OPR' || FUNCOD || TO_CHAR(TRNDAT, 'DDMMYYYY')
                           FROM CAIXA_GERAL
                          WHERE CXGID IN (735))
;

DELETE
  FROM MOVIMENTACAO_CATEGORIA
 WHERE LOJ_CODIGO = 1
   AND MCAT_CODIGO_ORIGEM IN (735)
   AND MCAT_TIPO = 'VENDA'
   AND MCAT_OPERACAO = 'RECEITA'
;

UPDATE CAIXA_GERAL
   SET SITUACAO = 'ABERTO'
     , TIPO_FECHA = NULL
     , MOTIVO_FECHA = NULL
     , OBSERVACAO = NULL
     , VLR_CALCULADO = NULL
 WHERE CXGID IN (735)
;

UPDATE TRANSACAO
   SET TRNFECHAMENTO = NULL
 WHERE TRNFECHAMENTO IN (735)
;


E depois deve ser feito o reprocessamento da conta corrente.

É necessario que o atendimento acesse a tela de lançamento de conta corrente, apertar o F12, na aba "CONSOLE", coloque o seguinte comando jQuery.abrePopUpReprocessamento(); 
e entre com as informações de conta corrente e data para realizar o reprocessamento
