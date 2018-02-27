update preco p set prccst = (select p1.prccst from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 2;
update preco p set proprccstmed = (select p1.proprccstmed from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 2;
update preco p set proprccstfis = (select p1.proprccstfis from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 2;
update preco p set prccst = (select p1.prccst from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 3;
update preco p set proprccstmed = (select p1.proprccstmed from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 3;
update preco p set proprccstfis = (select p1.proprccstfis from preco p1 where p1.lojcod = 1 and p1.procod = p.procod) where p.lojcod = 3;