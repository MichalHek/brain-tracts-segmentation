    function [ fourier_coff ] = feature_FFT( fibers )
    %the function calculates the fft of each coordinate vector
    %the output will be the first 10 coff of each coordinate
    %overall 30 outputs

    x = fibers(:,1:3:end);
    y = fibers(:,2:3:end);
    z = fibers(:,3:3:end);


    for i = 1:size(x,1)
        [~,u] = find(~isnan(x(i,:)));
        fft_x(:,i) = fft(x(i,u)');
        end
        real_fftx = real(fft_x);
    img_fftx = imag(fft_x);
    coff_x = sqrt((real_fftx).^2+(img_fftx).^2);



    for i = 1:size(y,1)
        [~,u] = find(y(i,:)~=nan);
        fft_y(:,i) = fft(y(i,u)');
    end
    real_ffty = real(fft_y);
    img_ffty = imag(fft_y);
    coff_y = sqrt((real_ffty).^2+(img_ffty).^2);

    for i = 1:size(z,1)
        [~,u] = find(z(i,:)~=nan);
        fft_z(:,i) = fft(z(i,u)');
    end
    fft_z = fft(z');
    real_fftz = real(fft_z);
    img_fftz = imag(fft_z);
    coff_z = sqrt((real_fftz).^2+(img_fftz).^2);

    red = floor(length(coff_x(:,2:end))/19);

    coff_x_partial = zeros(19,1);
    coff_y_partial = zeros(19,1);
    coff_z_partial = zeros(19,1);

    for i = 0:18
        if i<18
            coff_x_partial(i+1,:) = mean(coff_x(red*i+1:red*(i+1)));
            coff_y_partial(i+1,:) = mean(coff_y(red*i+1:red*(i+1)));
            coff_z_partial(i+1,:) = mean(coff_z(red*i+1:red*(i+1)));
        else
            coff_x_partial(i+1,:) = mean(coff_x(red*i+1:length(coff_x(:,2:end))));
            coff_y_partial(i+1,:) = mean(coff_y(red*i+1:length(coff_y(:,2:end))));
            coff_z_partial(i+1,:) = mean(coff_z(red*i+1:length(coff_z(:,2:end))));
        end
    end

    fourier_coff = [coff_x_partial; coff_y_partial; coff_z_partial]';
    end

