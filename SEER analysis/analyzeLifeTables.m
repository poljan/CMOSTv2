clear variables;

LT = readLifeTable('US.1970thru2014.individual.years.txt');
%LT is 4 dimensional matrix, (age, sex, race, year)
%Male = 2, Female = 3
%White = 2

%%
LTold = readtable('../Settings/Life Table 2003.xls');
%%
figure(1)
clf
hold on
for i = 1988:2000
    plot(1-LT(:,2,3,i-1))
end
plot(LTold.male(1:100),'r--')
hold off
set(gca,'YScale','log')

figure(2)
clf
hold on
for i = 1988:2000
    plot(1-LT(:,3,3,i-1))
    
end
plot(LTold.female(1:100),'r--')
hold off
set(gca,'YScale','log')
