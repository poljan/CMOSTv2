function table = readLifeTable( file )

%4 dimensional matrix, (age, sex, race, year)
%in each entry probability of survival
data = textread(file,'%s');
data = reshape(data,2,[])';

pos.age = 1:3;
pos.sex = 4;
pos.race = 5:6;
pos.year = 7:10;

table = [];
for i = 1:size(data,1)
    age = str2num(data{i,1}(pos.age));
    sex = str2num(data{i,1}(pos.sex));
    race = str2num(data{i,1}(pos.race));
    year = str2num(data{i,1}(pos.year));
    surv = str2num(data{i,2});
    
    table(age+1,sex+1,race+1,year+1) = surv/10^6;
end

table = single(table);

end