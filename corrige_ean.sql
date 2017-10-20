update produtoaux x set procodaux = (select substring(x1.procodaux,7) from produtoaux x1 where x1.procod = x.procod);

update produtoaux x set proauxcodigoean = cast((select substring(x1.procodaux,1,13) from produtoaux x1 where x1.procod = x.procod) as bigint);

INSERT INTO FILA_SINCRONIZACAO_PANAMA (ID, IDENTIFICADOR, PRIORIDADE, BODY, OPERACAO)
    (SELECT NEXTVAL('SQ_FILA_SINCRONIZACAO_PANAMA'), 'EAN', 0, TO_JSON(AUXILIARES), 'ATUALIZACAO'
     FROM (SELECT UPPER(PROCODAUX)::TEXT AS "id",
                  PROCOD::TEXT AS "produtoId"
           FROM PRODUTOAUX)
    AUXILIARES);