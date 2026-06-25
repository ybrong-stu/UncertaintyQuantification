function p = Pcc(f,y)
%
avgf = mean(f);
avgy = mean(y);
nume = (f-avgf).*(y-avgy);
nume = sum(nume);
denf = (f-avgf).^2;
denf = sqrt(sum(denf));
deny = (y-avgy).^2;
deny = sqrt(sum(deny));
p = nume/(denf*deny);

