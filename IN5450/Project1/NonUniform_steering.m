%% Beamwidth for kx
M = 24;
N = 5000;
P = ASAparameters;

DXs = [P.lambda/4 P.lambda/2 P.lambda 2*P.lambda];
ks = linspace(-1,1,N);
kx = 2*pi/P.lambda*ks;

weights = ones(M, 1);

figure(6);
t = tiledlayout(4,1);
titles = ["$d=1/4\lambda$","d=$1/2\lambda$","d=$\lambda$","d=$2\lambda$"];
for dx_idx = 1:numel(DXs)
    % Array "Case B"
    n = 1:2:24;
    d = DXs(dx_idx); % = 1/2; % Corresponding to lambda/2
    e_n = [-0.017 -0.538 -0.617 -1.000 -1.142 -1.372 -1.487 ...
           -1.555 -1.537 -1.300 -0.772 -0.242];
    
    d_n = (n/2 + e_n)*d;
    ElPos = [-fliplr(d_n) d_n];
    
    W = beampattern(ElPos, kx, weights);

    nexttile, plot(ks, db(abs(W))), grid on
    title(titles(dx_idx), "Interpreter","latex", "FontSize",15)
end
xlabel(t, "$k_x$", "Interpreter","latex", "FontSize",18);
ylabel(t, "Response [dB]", "FontSize", 14)
style_plot(gcf(), "nord");
exportgraphics(gcf, "6a.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Mainlobe width, sidelobe height and gain

% Array
d = P.lambda/2; % Corresponding to lambda/2
e_n = [-0.017 -0.538 -0.617 -1.000 -1.142 -1.372 -1.487 ...
       -1.555 -1.537 -1.300 -0.772 -0.242];

d_n = (n/2 + e_n)*d;
ElPos = [-fliplr(d_n) d_n];

M = numel(ElPos);
a = exp(-1j * kx.' * ElPos);

betas = 0:0.5:5;
comp2 = zeros(size(betas, 2), 4); % (-3, -6, side, GW)

for beta_idx = 1:numel(betas)
    win = kaiser(M, betas(beta_idx));
    norm_win = win/sum(win(:));
    W = beampattern(ElPos, kx, norm_win);

    analyze = analyzeBP(ks, W);
    
    GW = (norm(W' * a).^2) / (W'*W);
    GW = 1 / norm(norm_win)^2;

    comp2(beta_idx, :) = [analyze.Three_dB, analyze.Six_dB, analyze.maxSL, GW];
end

figure(7);
t = tiledlayout(4,1);
nexttile; hold on; grid on; title("-3 dB width"); 
ylabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 12);
plot(betas, comp(:, 1), "LineWidth",0.7);
plot(betas, comp2(:,1), "LineWidth",0.7);
legend(["ULA", "Non-Uniform Array"]);

nexttile; hold on; grid on; title("-6 dB width"); 
ylabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 12);
plot(betas, comp(:, 2), "LineWidth",0.7);
plot(betas, comp2(:,2), "LineWidth",0.7); 
legend(["ULA", "Non-Uniform Array"]);

nexttile; hold on; grid on; title("Sidelobe height"); 
ylabel("dB", "Interpreter","latex", "FontSize", 12);
plot(betas, comp(:, 3), "LineWidth",0.7);
plot(betas, comp2(:,3), "LineWidth",0.7); 
legend(["ULA", "Non-Uniform Array"]);

nexttile; hold on; grid on; title("White noise gain");
plot(betas, comp(:, 4), "LineWidth",0.7);
plot(betas, comp2(:,4), "LineWidth",0.7); 
legend(["ULA", "Non-Uniform Array"]);

xlabel(t, "$\beta$", "Interpreter", "latex", "FontSize", 18)
ylabel(t, "Value", "FontSize", 14)
style_plot(gcf(), "nord")
exportgraphics(gcf, "6b.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Steering (7)
N = 5000;
ks = linspace(-2, 2, N);
kx = 2*pi/P.lambda*ks;
k0 = 2*pi/P.lambda*sin(1.1018);

norm_win=weights/sum(weights(:));

W1 = beampattern(ElPos, kx - k0, norm_win);
W2 = beampattern(ElPos, kx, norm_win);

figure(8);close(8);figure(8);
hold on;
plot(ks, db(abs(W1)), "LineWidth", 0.7);
plot(ks, db(abs(W2)), "LineWidth", 0.7);
hold off;
legend(["Steered 60deg", "Unsteered"]);
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 15);
ylabel("Response [dB]");
title("Non-uniform linear array steered by 60deg")
style_plot(gcf(), "nord");
exportgraphics(gcf, "7a.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Steering Uniform array (7.2)
W1 = beampattern(xpos, kx - k0, norm_win);
W2 = beampattern(xpos, kx, norm_win);

figure(9);close(9);figure(9);
hold on;
plot(ks, db(abs(W1)), "LineWidth", 0.7);
plot(ks, db(abs(W2)), "LineWidth", 0.7);
hold off;
legend(["Steered 60deg", "Unsteered"]);
xlabel("$\sin(\theta)$", "Interpreter","latex", "FontSize", 15);
ylabel("Response [dB]");
title("Uniform linear array steered by 60deg")
style_plot(gcf(), "nord");
exportgraphics(gcf, "7b.pdf", "BackgroundColor", "none", "ContentType", "vector")

%% Compute (8)

N = 2000;
theta = linspace(0, pi, N);
ks = linspace(-2,2,N);
kx = 2*pi/P.lambda*ks;
k0 = 2*pi/P.lambda*sin(theta);

comp3 = zeros(numel(k0), 2); % (-3db, -6db)

for idx = 1:numel(k0)
    W = beampattern(ElPos, kx - k0(idx), norm_win);
    analyze = analyzeBP(ks, W);
    comp3(idx, :) = [analyze.Three_dB, analyze.Six_dB];
end

%% Report (8)

figure(10); close(10); figure(10);

x1 = rad2deg(theta);
y1 = abs(comp3(:, 1));
plot(x1,y1);
xlabel("Angle $\theta$ [deg]", "Interpreter","latex")
ylabel("Width")

x2 = sin(theta);
hAx(1) = gca;
hAx(2) = axes('Position',hAx(1).Position, 'XAxisLocation', 'top', 'YAxisLocation', 'left', 'Color', 'none');
hold(hAx(2), 'on');
plot(hAx(2), x2, y1)
xlabel(hAx(2), "$\sin(\theta)$", "Interpreter","latex")

