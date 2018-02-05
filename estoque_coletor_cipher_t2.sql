SELECT TRIM(PROCODAUX),ESTATU 
    FROM ESTOQUE E 
    INNER JOIN PRODUTOAUX X ON E.PROCOD = X.PROCOD
    INNER JOIN PRODUTO P ON E.PROCOD = P.PROCOD 
WHERE PROFORLIN = 'N' ORDER BY P.PROCOD