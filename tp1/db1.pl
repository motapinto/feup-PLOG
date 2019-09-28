parent(ella_scofield, michael_scofield).
parent(ella_scofield, sara_tancredi).
parent(lj_burrows,  lincoln_burrows).
parent(lj_burrows,  lisa_rix).
parent(lincoln_burrows, aldo_burrows).
parent(lincoln_burrows, christina_scofield).
parent(michael_scofield, christina_scofield).
parent(michael_scofield, aldo_burrows).

male(michael_scofield).
male(lincoln_burrows).
male(lj_burrows).
male(aldo_burrows).

female(ella_scofield).
female(christina_scofield).
female(sara_tancredi).
female(lisa_rix).

parents(Child, Dad, Mom):
    male(Dad), female(Mom), parent(Child, Dad), parent(Child, Mom).