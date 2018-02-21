select 
 p.procod as CODIGO,
 prodes as DESCRIÇÃO,
 natcodigo as NATUREZA,
 impfedst as CST_ENTRADA_PIS_COFINS, 
 impfedstsai as CST_SAIDA_PIS_COFINS
from 
 produto p 
inner join impostos_federais_produto i on p.procod = i.procod
inner join impostos_federais f on i.impfedsim = f.impfedsim
where 
 natcodigo in (419,420,423)
group by p.procod,prodes,natcodigo,impfedst,impfedstsai
order by p.procod