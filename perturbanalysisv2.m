%% Analyze Perturbation
clear, clc, close all
rng(666) % For reproducibility
% strvals = [0.1 1 10];
strvals = linspace(0.1, 100, 50);
projectfolder = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\";
cd(projectfolder)
cd C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL
figdir = projectfolder + "figures\";
ntrials = 20;
nsamples = 100/(0.1/1000)+1;
pinkgenerator = dsp.ColoredNoise('Color', 'pink', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
browngenerator = dsp.ColoredNoise('Color', 'brown', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
whitegenerator = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);

noises = {whitegenerator(), pinkgenerator(), browngenerator()};
noisecolors = ["#BEC2CB", "m", "#D95319"];
noisenames = ["white", "pink", "brown"];
shading = [0.3010 0.7450 0.9330];

% Get the area of unperturbed circle
[x, y, time] = SL();
indx = time > 50;
surfarea = polyarea(x(indx), y(indx));

for j = 1:length(strvals)
    str = strvals(j);
    for k = 1:length(noises)
        for i = 1:ntrials
            noise = noises{k}(:, i);
            noise = ((noise - min(noise)) / (max(noise) - min(noise))) * (str - (-str)) + (-str);
            [x(:, i), y(:, i), time] = SL("I", noise);
            disp("trial " + i + " done")
        end
        idx = time > 50;
        time = time(idx)';
        xs = x(idx, :);
        ys = y(idx, :);
        pertsurf(j, k, :) = abs(polyarea(xs, ys) - surfarea); % Rows: Noise strength, Columns: Noise color, 3rd dim: Trials
    end
end

meanpert = mean(pertsurf, 3);
sepert = std(pertsurf, [], 3) / sqrt(ntrials);
patchstr = [strvals'; flip(strvals')];
patchpert = [meanpert + sepert; flipud(meanpert - sepert)];
for i = 1:3
    plot(strvals, meanpert(:, i), 'LineWidth', 2, 'Color', noisecolors{i})
    hold on
    patch(patchstr, patchpert(:, i), shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None', 'HandleVisibility','off');
end
xlabel('Noise strength')
ylabel('Perturbation')
legend(["White Noise", "Pink Noise", "Brown Noise"], 'Location', 'NorthWest')
figdir = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\figures\";
export_fig(char(figdir + "strvscolor.png"), '-transparent', '-r1000')
close

%% Different Noise Colors vs Strengths

clear, clc, close all
rng(666) % For reproducibility
strvals = [10 30 50];
plevals = linspace(0, 2, 20);
projectfolder = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\";
cd(projectfolder)
cd C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL
figdir = projectfolder + "figures\";
ntrials = 20;
nsamples = 100/(0.1/1000)+1;
% noisecolors = ["#BEC2CB", "m", "#D95319"];
noisecolors = [0.745 0.761 0.796;
    1 0 1;
    0.8500 0.3250 0.0980];
shading = [0.3010 0.7450 0.9330];

% Get the area of unperturbed circle
[x, y, time] = SL();
indx = time > 50;
surfarea = polyarea(x(indx), y(indx));

for j = 1:length(plevals)
    
    generator = dsp.ColoredNoise('InverseFrequencyPower', plevals(j), 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
    noise = generator();
    for z = 1:length(strvals)
        noise = ((noise - min(noise)) ./ (max(noise) - min(noise))) .* (strvals(z) - (-strvals(z))) + (-strvals(z));
        for i = 1:ntrials
            [x(:, i), y(:, i), time] = SL("I", noise(:, i));
            disp("trial " + i + " done")
        end
        idx = time > 50;
        time = time(idx)';
        xs = x(idx, :);
        ys = y(idx, :);
        pertsurf(j, z, :) = abs(polyarea(xs, ys) - surfarea); % Rows: PLE, Columns: Noise Strength, 3rd dim: Trials
    end
end

meanpert = mean(pertsurf, 3);
sepert = std(pertsurf, [], 3) / sqrt(ntrials);
patchstr = [plevals'; flip(plevals')];
patchpert = [meanpert + sepert; flipud(meanpert - sepert)];
for i = 1:3
    plot(-plevals, meanpert(:, i), 'LineWidth', 2)
    hold on
    patch(patchstr, patchpert(:, i), shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None', 'HandleVisibility','off');
end
xlabel('PLE of noise')
ylabel('Perturbation')
legend(["Noise Strength = " + strvals(1), "Noise Strength = " + strvals(2), "Noise Strength = " + strvals(3)], ...
    'Location', 'NorthWest')
set(gca, 'XDir','reverse')

patch([0 0.2 0.2 0], [max(ylim) max(ylim) min(ylim) min(ylim)], noisecolors(1, :), 'FaceAlpha', 0.3, ...
    'EdgeColor', 'None', 'HandleVisibility','off')
patch([0.5 1.5 1.5 0.5], [max(ylim) max(ylim) min(ylim) min(ylim)], noisecolors(2, :), 'FaceAlpha', 0.3, ...
    'EdgeColor', 'None', 'HandleVisibility','off')
patch([1.8 2 2 1.8], [max(ylim) max(ylim) min(ylim) min(ylim)], noisecolors(3, :), 'FaceAlpha', 0.3, ...
    'EdgeColor', 'None', 'HandleVisibility','off')
xlim([0 2])

figdir = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\figures\";
export_fig(char(figdir + "plevscolor.png"), '-transparent', '-r1000')
close























