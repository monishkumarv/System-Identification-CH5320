%%% Q.1
syms k1 k2 k3 w

M = [cos(w*(k1-1))^2,cos(w*(k1-2))^2,cos(w*(k1-3))^2; 
     cos(w*(k2-1))^2,cos(w*(k2-2))^2,cos(w*(k2-3))^2;
     cos(w*(k3-1))^2,cos(w*(k3-2))^2,cos(w*(k3-3))^2];

simplify(det(M))

% --------------------------------------------------------------------------------- %

%%% Q.2 a)

for k=1:20
    g(k) = 2*((0.6)^(k-1)) + ((0.4)^(k-1));
end

impulse_response = g;

step_response(1) = g(1);


for k=2:20
    step_response(k) = step_response(k-1) + g(k);
end

figure; stem(impulse_response)
title('Impulse response estimates')
xlabel('Time')
ylabel('Amplitude')

figure; stem(step_response)
title('Step response estimates')
xlabel('Time')
ylabel('Amplitude')
 
% --------------------------------------------------------------------------------- %

%%% Q.2 b)

w = 0:0.001:pi;
G = ((exp(-1i.*w))./(1-0.4.*exp(-1i.*w))) + ((2.*exp(-1i.*w))./(1-0.6.*exp(-1i.*w)));

figure
subplot(2,1,1)
semilogx(w,abs(G))
xlabel('Frequency (rad/sample)')
ylabel('Magnitude')
ylim([0 8]); xlim([0 pi])

subplot(2,1,2)
semilogx(w,angle(G))
xlabel('Frequency (rad/sample)')
ylabel('Phase (rad)')
ylim([-4 1]); xlim([0 pi])

% --------------------------------------------------------------------------------- %

%%% Q.3 a)

y = [];
u = ones(50);
y(1) = 3; y(2) = 6.9;

for k=3:50
    y(k) = 3.*u(k-1) + 1.3.*y(k-1) - 0.24.*y(k-2);
end


figure; stem(y)
title('Step response estimates')
xlabel('Time')
ylabel('Amplitude')

% --------------------------------------------------------------------------------- %

%%% Q.3 b)

y = [];
u = zeros(50);
u(1) = 1;
y(1) = 3; y(2) = 3.9;

for k=3:50
    y(k) = 3.*u(k-1) + 1.3.*y(k-1) - 0.24.*y(k-2);
end


figure; stem(y)
title('Impulse response estimates')
xlabel('Time')
ylabel('Amplitude')

% --------------------------------------------------------------------------------- %

%%% Q.4

sim('liqlevel_exch01.mdl');
dataset = iddata(yk ,uk ,1);
dataset. OutputName = 'Level'; dataset. InputName = 'Flow';
dataset.TimeUnit = 'minutes';

% Partition data into training and test data
% Use means of training data as the reference point
datatrain = dataset (1:1500); datatest = dataset (1501:end);
[Ztrain ,Tr] = detrend(datatrain ,0);
Ztest = detrend(datatest ,Tr);

% 99 % significance levels
clim = 2.58/sqrt(length(Ztrain.y));

% --------------------------------------------------------------------------------- %

%%% Q.4.a)

% Output-error model:
mod_oe = oe(Ztrain ,[1 1 1]);
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
mod_arx = arx(Ztrain ,[1 1 1]);
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









