% Alexander Belsten 07/10/2021
% The Laplacian Pyramid as a Compact Image Code
% Peter J. Burt, Edwared H. Adelson - 1983

clear all; close all; clc;

settings.a                = 0.3;
settings.input_image      = 'example.png';
settings.N                = 6;
settings.output_directory = 'results';
mkdir(settings.output_directory);

%% make filter
w_t = ones(5, 1);
w_t(3) = settings.a;
w_t(2) = 1/4; w_t(4) = w_t(2);
w_t(1) = 1/4 - settings.a/2; w_t(5) = w_t(1);
w = zeros(5,5);
for m = 1:5
    for n=1:5
        w(m,n) = w_t(m)*w_t(n);
    end
end

clear w_t m n;
%% construct gaussian pyramid 
%   with REDUCE method
gaussian_pyramid    = cell(settings.N, 1);
gaussian_pyramid{1} = double(imread(settings.input_image))-128; 

for k=2:settings.N 
    gaussian_pyramid{k} = REDUCE(gaussian_pyramid{k-1}, w);
end

clear k;
%% save gaussian pyramid
for k=1:settings.N
    imwrite(uint8(gaussian_pyramid{k}+128),[settings.output_directory, sprintf('/gaussian_pyramid_layer_%d.png', k)]);
end

clear k;
%% construct laplacian pyramid
%   with EXPAND method
laplacian_pyramid = cell(settings.N, 1);
for k=1:(settings.N-1)
    laplacian_pyramid{k} = gaussian_pyramid{k} - EXPAND(gaussian_pyramid{k+1},w);
end

% set the top image in the laplacian equal to the top element in the
% gaussian
laplacian_pyramid{settings.N} = gaussian_pyramid{settings.N};

clear k;
%% save laplacian pyramid
for k=1:settings.N
    imwrite(uint8(laplacian_pyramid{k}+128),[settings.output_directory, sprintf('/laplacian_pyramid_layer_%d.png', k)]);
end

clear k;
%% validate we get the same image when summing over laplacian 
recovered_images = cell(settings.N, 1);
recovered_images{settings.N} = laplacian_pyramid{settings.N};

% expand top image in pyramid and add it to the image below 
recovered_images{settings.N-1} = laplacian_pyramid{settings.N-1} + EXPAND(recovered_images{settings.N} , w);
for k=(settings.N-1):-1:2

    % take our recovered image, expand it and add it to the lower level in
    % laplacian. This is our new recovered image
    recovered_images{k-1} = laplacian_pyramid{k-1} + EXPAND(recovered_images{k}, w);
end

clear k;
%% save images throughout recovery
for k=1:settings.N
    imwrite(uint8(recovered_images{k}+128),[settings.output_directory, sprintf('/recovered_image_%d.png', k)]);
end

clear k;
%% 

fprintf('%e\n', norm(gaussian_pyramid{1}-recovered_images{1}))
