DO language plpgsql $$
DECLARE
    codigoAntigo PESSOA_CLIENTE.CLI_CODIGO%TYPE;
    proximoCodigo PESSOA_CLIENTE.CLI_CODIGO%TYPE;
BEGIN
    for codigoAntigo in SELECT CLI_CODIGO FROM PESSOA_CLIENTE where CLI_CODIGO  > 999999
    LOOP
            SELECT CASE
            WHEN (SELECT MIN(P1.CLI_CODIGO) FROM PESSOA_CLIENTE P1) > 1 THEN 1 
            WHEN (SELECT MIN(P1.CLI_CODIGO) FROM PESSOA_CLIENTE P1) IS NULL THEN 1 
            ELSE ( 
                 SELECT MIN(P1.CLI_CODIGO+1) 
                 FROM PESSOA_CLIENTE P1 
                 left outer join (SELECT CLI_CODIGO - 1 AS CODIGO FROM PESSOA_CLIENTE) P2 on p1.CLI_CODIGO = P2.CODIGO 
                 WHERE P2.CODIGO IS NULL 
            ) 
            END into proximoCodigo 
            FROM PROPRIO;

            UPDATE PESSOA_CLIENTE SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE LIMITE_DE_CREDITO SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE CONTA_A_RECEBER SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE CODIGOS_INTERNOS SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE COBRANCA SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE TRANSACAO_LIQUIDACAO SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            UPDATE TRANSACAO_VENDA_PRAZO SET CLI_CODIGO = proximoCodigo WHERE CLI_CODIGO = codigoAntigo;
            RAISE NOTICE '%', 'CODIGO ANTIGO: ' || codigoAntigo || ', CODIGO NOVO: ' || proximoCodigo;
            
    END LOOP;
    
END;
$$;