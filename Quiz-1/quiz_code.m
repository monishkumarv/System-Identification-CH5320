%%% Q.4

sim('quiz1_sys_2019b.slx');
dataset = iddata(yk ,uk ,1);
dataset. OutputName = 'Level'; dataset. InputName = 'Flow';
dataset.TimeUnit = 'minutes';

% Partition data into training and test data
% Use means of training data as the reference point
datatrain = dataset;
[Ztrain ,Tr] = detrend(datatrain ,0);

% 99 % significance levels
clim = 2.58/sqrt(length(Ztrain.y));

% --------------------------------------------------------------------------------- %
%%% Q.4.a)

% Output-error model:
mod_oe = oe(Ztrain ,[1 1 3]);
present(mod_oe)
yhat_oe = predict(mod_oe , Ztrain );       % Predictions on training data
err_oe = pe(mod_oe , Ztrain );             % Compute one-step ahead prediction errors

% Residual analysis:
cross_corr_oe = xcov(err_oe.y, Ztrain.u,24,'coeff');
acf_oe = xcov(err_oe.y,20,'coeff');

% Plot
figure
subplot(211); stem( -24:24 , cross_corr_oe ); hold on
plot([ -24 24] ,[1 1]* clim ,'r--' ,[-24 24] ,[ -1 -1]*clim ,'r--')
title('Correlation between residuals and inputs (OE Model)')

subplot(212); stem((0:20) ,acf_oe (21:end)); hold on
plot([0 20] ,[1 1]* clim ,'r--' ,[0 20] ,[ -1 -1]*clim ,'g--')
title('Auto-correlation funtion of residuals (OE Model)')

% --------------------------------------------------------------------------------- %

%%% Q.4.b)

% Equation-error model:
mod_arx = arx(Ztrain ,[1 1 3]);
present(mod_arx)
yhat_arx = predict(mod_arx, Ztrain );      % Predictions on training data
err_arx = pe(mod_arx , Ztrain );           % Compute one-step ahead prediction errors


% Residual analysis:
cross_corr_arx = xcov(err_arx.y, Ztrain.u, 24,'coeff');
acf_arx = xcov(err_arx.y,20,'coeff');

% Plot
figure
subplot(211); stem( -24:24 , cross_corr_arx ); hold on
plot([ -24 24] ,[1 1]* clim ,'r--' ,[-24 24], [ -1 -1]*clim ,'r--')
title('Correlation between residuals and inputs (ARX Model)')

subplot(212); stem((0:20) ,acf_arx (21:end)); hold on
plot([0 20] ,[1 1]* clim ,'r--' ,[0 20] ,[ -1 -1]*clim ,'g--')
title('Auto-correlation funtion of residuals (ARX Model)')









