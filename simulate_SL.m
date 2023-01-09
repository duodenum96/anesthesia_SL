%% Simulate SL and get results
clear, clc, close all
rng(666) % For reproducibility
strvals = [0.1 1 10];
projectfolder = "C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL\";
cd(projectfolder)
cd C:\Users\user\Desktop\brain_stuff\philipp\anesthesia_SL
figdir = projectfolder + "figures\";
ntrials = 5;
nsamples = 100/(0.1/1000)+1;
pinkgenerator = dsp.ColoredNoise('Color', 'pink', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
browngenerator = dsp.ColoredNoise('Color', 'brown', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);
whitegenerator = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', nsamples, 'NumChannels', ntrials);

noises = {whitegenerator(), pinkgenerator(), browngenerator()};
noisecolors = ["#BEC2CB", "m", "#D95319"];
noisenames = ["white", "pink", "brown"];

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
        x_se = std(x(idx, :), [], 2);
        noise_mean = mean(noisemat(idx, :), 2);
        noise_se = std(noise(idx, :), [], 2);
        patchnoise = [noise_mean-noise_se; fliplr(noise_mean+noise_se)];
        
        patchtime = [time; flipud(time)];
        patchx = [x_mean-x_se; fliplr(x_mean+x_se)];
        
        y_mean = mean(y(idx, :), 2);
        y_se = std(y(idx, :), [], 2);
        patchy = [y_mean-y_se; fliplr(y_mean+y_se)];
        
        % Plot
        figure;
        set(gcf, 'Position', [374.6000 588.2000 656.8000 174.8000]);
        subplot(1,4,1)
        plot(time, noise_mean, 'Color', noisecolors(k), 'LineWidth', 2)
        hold on
        patch(patchtime, patchnoise, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        subplot(1,4,2)
        plot(time, x_mean, 'k')
        hold on
        patch(patchtime, patchx, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        subplot(1,4,3)
        plot(time, y_mean, 'g')
        hold on
        patch(patchtime, patchy, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        xlim([50 100])
        subplot(1,4,4)
        plot(x_mean, y_mean, 'Color', noisecolors(k))
        hold on
        patch(patchx, patchy, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'None')
        
        figname = figdir + noisenames(k) + "_" + num2str(str) + ".png";
%         export_fig(figname, '-transparent', '-r1000')
        saveas(gcf, figname)
        close
        
    end
end
    




































