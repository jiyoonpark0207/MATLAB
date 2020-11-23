
% test_DWT_CD.m
% interested in knowing xc, xd

close all;
clear;
clc;

% original signal
K = 500;
t = linspace(0, 2*pi, K);
x = sin(t) + 0.1*randn(1, K);

% Haar wavelet filters
% lo = [1, 1]/sqrt(2); % h = [h0, h1]
% hi = [lo(2), -lo(1)]; % g = [h1, -h0]

% Daubechies wavelet filters
lo = [1+sqrt(3), 3+sqrt(3), 3-sqrt(3), 1-sqrt(3)]/(4*sqrt(2));
hi = lo( end:-1:1 );
hi = hi .* [1, -1, 1, -1];

% DWT, decomposition
[c, d] = DWT(x, lo, hi);

% IDWT, reconstruction
x1 = IDWT(c, d, lo, hi, length(x));
% [x1, xc, xd] = IDWT(c, d, lo, hi, length(x));

% reconstruction
len_c = length( c );
xc = IDWT( c, zeros( 1, len_c ), lo, hi, length(x) );
xd = IDWT( zeros( 1, len_c ), d, lo, hi, length(x) );

% reconstruction error
fprintf('max error = %10.4e\n', max( abs( x - x1 ) ));

% plot
figure;
subplot(4, 1, 1);
plot(x);
title('original signal');

subplot(4, 1, 2);
plot(d);
title('detail coefficients');

subplot(4, 1, 3);
plot(c);
title('core coefficients');

subplot(4, 1, 4);
plot(x1);
title('reconstructed signal');

figure;
subplot(4, 1, 1);
plot(x);
title('original signal');

subplot(4, 1, 2);
plot(xd);
title('detail signal');

subplot(4, 1, 3);
plot(xc);
title('core signal');

subplot(4, 1, 4);
plot(x1);
title('reconstructed signal');





%%
function [c, d] = DWT(x, lo, hi)

    len_lo = length(lo);
    len_ext = len_lo - 1;
    len_x = length(x);
    x_ext = [ x(len_ext:-1:1), x, x(len_x:-1:(len_x-len_ext+1)) ];
    
    lo_re = lo( end:-1:1 );
    hi_re = hi( end:-1:1 );
    c = conv(x_ext, lo_re, 'valid');
    d = conv(x_ext, hi_re, 'valid');

    c = c( 2:2:end );
    d = d( 2:2:end );

end

function x = IDWT(c, d, lo, hi, len_x)
% function [x, xc, xd] = IDWT(c, d, lo, hi, len_x)


    len_c = length(c);
    
    if mod( len_x, 2 ) == 0
        extra = 1;
    else
        extra = 0;
    end
    
    c_up = zeros(1, 2*len_c+extra);
    c_up(2:2:end) = c;
    
    d_up = zeros(1, 2*len_c+extra);
    d_up(2:2:end) = d;

    xc = conv(c_up, lo, 'valid');
    xd = conv(d_up, hi, 'valid');

    x = xc + xd;    
    
end














