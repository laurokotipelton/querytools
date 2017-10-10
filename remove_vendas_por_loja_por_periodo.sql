DO language plpgsql $$
DECLARE
        L BIGINT;
        D1 DATE;
        D2 DATE;

begin
        L := 1;
        D1 := '2017-03-01';
        D2 := '2017-03-31';

RAISE NOTICE '% - PROCESSO INICIADO.', timeofday()::timestamp;
	
	DELETE FROM REDUCAO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
	DELETE FROM ESTATISTICA_PRODUTO_VENDA WHERE EPV_DATA_VENDA BETWEEN D1 AND D2 AND EPV_LOJCOD = L;
        DELETE FROM ESTOQUE_MOVIMENTACAO WHERE MOV_ID IN (
            SELECT
                    MOV_ID
            FROM
                    ESTOQUE_MOVIMENTACAO
            WHERE
                    MOV_TIPO='VENDA' AND
                    LOJ_CODIGO = L AND
                    MOV_DATA BETWEEN D1 AND D2 
        );
        DELETE FROM TRANSACAO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM ITEM_VENDA WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM FINALIZACAO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM TRANSACAOITEMTEFDLL WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM TRANSACAOTEFDLL WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM ITEM_RECEBIMENTO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM ITEM_PAGAMENTO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM ITEM_PLANO_PAGAMENTO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM PREVENDA WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM OCORRENCIA_PDV WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM SANGRIA_CONCILIACAO WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
        DELETE FROM TRANSACAO_XMLNOTA WHERE LOJCOD = L AND TRNDAT BETWEEN D1 AND D2;
	
RAISE NOTICE '% - PROCESSO CONCLUIDO.', timeofday()::timestamp;

end
$$;