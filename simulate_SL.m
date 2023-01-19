%% Simulate SL and get results
clear, clc, close all
rng(666) % For reproducibility
strvals = [5 10 20];
projectfolder = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\";
cd(projectfolder)
cd C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL
figdir = projectfolder + "figures\";
ntrials = 50;
nsamples = 100/(0.1/1000)+1;
pinkgenerator = dsp.ColoredNoise('Color', 'pink', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
browngenerator = dsp.ColoredNoise('Color', 'brown', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
whitegenerator = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);

noises = {whitegenerator(), pinkgenerator(), browngenerator()};
noisecolors = ["#BEC2CB", "m", "#D95319"];
noisenames = ["white", "pink", "brown"];
shading = [0.3010 0.7450 0.9330];

for j = 1:length(strvals)
    str = strvals(j);
    for k = 1:length(noises)
        for i = 1:ntrials
            noise = noises{k}(:, i);
            noise = ((noise - min(noise)) / (max(noise) - min(noise))) * (str - (-str)) + (-str);
            [x(:, i), y(:, i), time] = SL("I", noise);
            noisemat(:, i) = noise; % This is ugly...
            disp("trial " + i + " done")
        end
        idx = time > 50;
        time = time(idx)';
        x_mean = mean(x(idx, :), 2);
        x_se = std(x(idx, :), [], 2) / sqrt(ntrials);
        noise_mean = mean(noisemat(idx, :), 2);
        noise_se = std(noisemat(idx, :), [], 2) / sqrt(ntrials);
        patchnoise = [noise_mean-noise_se; flipud(noise_mean+noise_se)];
        
        patchtime = [time; flipud(time)];
        patchx = [x_mean-x_se; flipud(x_mean+x_se)];
        
        y_mean = mean(y(idx, :), 2);
        y_se = std(y(idx, :), [], 2) / sqrt(ntrials);
        patchy = [y_mean-y_se; flipud(y_mean+y_se)];
        
        % Plot
        figure;
        set(gcf, 'Position', [374.6000 588.2000 656.8000 174.8000]);
        subplot(1,4,1)
        plot(time, noise_mean, 'Color', noisecolors(k), 'LineWidth', 1.2)
        hold on
        patch(patchtime, patchnoise, shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        axis square
%         ylim([-4 4])
        title("Noise Strength = " + str)
%         ytickformat('%.2d')
        subplot(1,4,2)
        plot(time, x_mean, 'k', 'LineWidth', 1.2)
        hold on
        patch(patchtime, patchx, shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        title('Oscillator 1')
        axis square
%         ytickformat('%.2d')
        subplot(1,4,3)
        plot(time, y_mean, 'g', 'LineWidth', 1.2)
        hold on
        patch(patchtime, patchy, shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        title('Oscillator 2')
        axis square
%         ytickformat('%.2d')
        subplot(1,4,4)
        plot(x_mean, y_mean, 'Color', noisecolors(k), 'LineWidth', 1.2)
        hold on
        patch(patchx, patchy, shading, 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        axis square
        title('Phase Space')
%         ytickformat('%.2d')
        
        figname = figdir + noisenames(k) + "_" + strrep(num2str(str), ".", "_") + ".png";
        export_fig(char(figname), '-transparent', '-r1000')
%         saveas(gcf, extractBefore(figname, ".png"))
        close
        
    end
end





























