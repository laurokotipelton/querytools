DO language plpgsql $$
DECLARE
        L BIGINT;
        C VARCHAR(3);
        D DATE;
        S VARCHAR(6);
begin
        L := 3;
        D := '2017-09-14';

        raise notice '% - Processo inicidao.', timeofday()::timestamp;

        DELETE FROM VENDA_CONSOLIDADA_PRODUTO WHERE LOJCOD = L AND VCPDAT = D;
        DELETE FROM VENDA_CONSOLIDADA_FINALIZADORA WHERE LOJCOD = L AND VCFDAT = D;
        DELETE FROM VENDA_CONSOLIDADA_LOJA WHERE LOJCOD = L AND VCLDAT = D;

        INSERT INTO VENDA_CONSOLIDADA_PRODUTO (ID, LOJCOD, VCPDAT, PROCOD, VCPQTD, VCPVLRTOT, VALOR_LUCRO_MARKUP, VALOR_LUCRO_MARGEM, VALOR_CUSTO)
        SELECT NEXTVAL('SQ_VENDA_CONSOLIDADA_PRODUTO')
             , T.LOJCOD
             , T.TRNDAT AS VCPDAT
             , IV.PROCOD as PROCOD
             , SUM(IV.ITVQTDVDA) AS VCPQTD
             , SUM(IV.ITVVLRTOT) AS VCPVLRTOT
             , SUM(ITVVLRTOT - (IV.ITVPRCCST * IV.ITVQTDVDA)) AS VALOR_LUCRO_MARKUP
             , SUM(ITVVLRTOT - (ITVVLRTOT * ITVTRBALQ / 100) - (ITVVLRTOT * ITVALQPIS / 100) - (ITVVLRTOT * ITVALQCOFINS / 100) - (ITVPRCCSTFIS * ITVQTDVDA)) AS VALOR_LUCRO_MARGEM
             , SUM(ITVPRCCST) AS VALOR_CUSTO
          FROM TRANSACAO T
          JOIN ITEM_VENDA IV ON (T.TRNSEQ  = IV.TRNSEQ
                            AND  T.CXANUM  = IV.CXANUM
                            AND  T.TRNDAT  = IV.TRNDAT
                            AND  T.LOJCOD  = IV.LOJCOD
                            AND  IV.ITVTIP = '1')
        WHERE T.TRNTIP = '1' AND T.LOJCOD = L AND T.TRNDAT = D
        GROUP BY T.LOJCOD, T.TRNDAT, IV.PROCOD;

        INSERT INTO VENDA_CONSOLIDADA_FINALIZADORA (ID, LOJCOD, VCFDAT, FZDCOD, VCFVLRTOT, VCFQTDCLI)
        SELECT NEXTVAL('SQ_VENDA_CONSOLIDADA_FIN')
             , LOJCOD
             , TRNDAT
             , FZDCOD
             , SUM(VCLVLRTOT) VCLVLRTOT
             , COUNT(*) AS VCLQTDCLI
          FROM (SELECT T.LOJCOD
                     , T.TRNDAT
                     , T.CXANUM
                     , T.TRNSEQ
                     , F.FZDCOD
                     , SUM(F.FZCVLR - F.FZCCTRVAL) VCLVLRTOT
                  FROM TRANSACAO T
                 INNER JOIN FINALIZACAO F ON (F.LOJCOD = T.LOJCOD
                                         AND  F.TRNDAT = T.TRNDAT
                                         AND  F.CXANUM = T.CXANUM
                                         AND  F.TRNSEQ = T.TRNSEQ)
                 WHERE T.TRNTIP = '1' AND T.LOJCOD = L AND T.TRNDAT = D
                 GROUP BY T.LOJCOD, T.TRNDAT, T.CXANUM, T.TRNSEQ, F.FZDCOD) R
         GROUP BY LOJCOD,TRNDAT,FZDCOD;

        INSERT INTO VENDA_CONSOLIDADA_LOJA (ID, LOJCOD, VCLDAT, VCLQTDCLI, VCLVLRTOT, TOTAL_LUCRO_MARKUP, TOTAL_LUCRO_MARGEM, TOTAL_CUSTO)
        SELECT NEXTVAL('SQ_VENDA_CONSOLIDADA_LOJA')
             , T1.LOJCOD
             , T1.TRNDAT AS VCPDAT
             , T2.CONTADOR AS VCLQTDCLI
             , SUM(IV.ITVVLRTOT) AS VCPVLRTOT
             , SUM(ITVVLRTOT - (IV.ITVPRCCST * IV.ITVQTDVDA)) AS TOTAL_LUCRO_MARKUP
             , SUM(ITVVLRTOT - (ITVVLRTOT * ITVTRBALQ / 100) - (ITVVLRTOT * ITVALQPIS / 100) - (ITVVLRTOT * ITVALQCOFINS / 100) - (ITVPRCCSTFIS * ITVQTDVDA)) AS TOTAL_LUCRO_MARGEM
             , SUM(ITVPRCCST) AS TOTAL_CUSTO
          FROM TRANSACAO T1
          JOIN ITEM_VENDA IV ON (T1.TRNSEQ  = IV.TRNSEQ
                            AND  T1.CXANUM  = IV.CXANUM
                            AND  T1.TRNDAT  = IV.TRNDAT
                            AND  T1.LOJCOD  = IV.LOJCOD
                            AND  IV.ITVTIP = '1')
         JOIN (SELECT T.LOJCOD, T.TRNDAT , count(*) as CONTADOR FROM TRANSACAO T WHERE T.TRNTIP = '1' GROUP BY T.LOJCOD, T.TRNDAT) T2 on (T2.LOJCOD = T1.LOJCOD and T2.TRNDAT = T1.TRNDAT)
         WHERE T1.TRNTIP = '1' AND T1.LOJCOD = L AND T1.TRNDAT = D
         GROUP BY T1.LOJCOD, T1.TRNDAT, T2.CONTADOR;

         raise notice '% - Processo concluido.', timeofday()::timestamp;
end
$$;