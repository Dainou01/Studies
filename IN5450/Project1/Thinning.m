P = ASAparameters;
NEls = 101;
NPos = 25;
d = P.lambda/2;
N = 1000;
u = linspace(-1,1,N); % sin(theta)
kx = 2*pi/P.lambda*u;
weights = ones(NPos, 1);
weights = weights/sum(weights(:));

Reps = 1000; % Repetions

comp = zeros(Reps, 3); % (-3db, -6db, side)

for ii = 1:Reps
    pos = [];
    while length(pos)<NPos - 2
        pos = unique(ceil((NEls-2)*rand(1,NPos*2)),'stable');
    end
    ElPos = [-(NEls-1)/2 sort(pos(1:NPos-2))-(NEls-1)/2 (NEls-1)/2]*d;
    
    Resp = beampattern(ElPos, kx, weights);
    analyze = analyzeBP(u, Resp);
    comp(ii, :) = [ analyze.Three_dB, analyze.Six_dB, analyze.maxSL ];
end

mean_3db = mean(comp(:, 1)); std_3db = std(comp(:, 1));
mean_6db = mean(comp(:, 2)); std_6db = std(comp(:, 2));
mean_slb = mean(comp(:, 3)); max_slb = std(comp(:, 3));

sprintf("Main lobe mean width @ -3dB: %.4f [± %.4f]", mean_3db, std_3db)
sprintf("Main lobe mean width @ -6dB: %.4f [± %.4f]", mean_6db, std_6db)
sprintf("Mean sidelobe level: %.4f\n Max sidelobe level: %.4f", mean_slb, max_slb)

%% Dense array with same properties

ElPos = linspace(-NEls*d/2, NEls*d/2, NEls);
Resp = beampattern(ElPos, kx, ones(NEls,1));
analyze = analyzeBP(u, Resp);
sprintf("Main lobe width @ -3dB: %.4f", analyze.Three_dB)
sprintf("Main lobe width @ -6dB: %.4f", analyze.Six_dB)
sprintf("Max sidelobe level: %.4f", analyze.maxSL)