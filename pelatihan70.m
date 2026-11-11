clc; clear; close all; warning off all;

% Inisialisasi folder citra latih
image_folder = 'D:\programskripsi\datalatih70';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

% Inisialisasi array untuk menyimpan fitur-fitur citra
fitur_area = zeros(1, total_images);
fitur_perimeter = zeros(1, total_images);
fitur_majorAxisLength = zeros(1, total_images);
fitur_minorAxisLength = zeros(1, total_images);
fitur_eccentricity = zeros(1, total_images);
fitur_mean_h = zeros(1, total_images);  % Rata-rata Hue
fitur_mean_s = zeros(1, total_images);  % Rata-rata Saturation
fitur_mean_v = zeros(1, total_images);  % Rata-rata Value
fitur_std_h = zeros(1, total_images);   % Deviasi standar Hue
fitur_std_s = zeros(1, total_images);   % Deviasi standar Saturation
fitur_std_v = zeros(1, total_images);   % Deviasi standar Value
fitur_lbp_mean = zeros(1, total_images);
fitur_lbp_std = zeros(1, total_images);

% Menghitung fitur-fitur untuk setiap citra latih
for n = 1:total_images
    % Mendapatkan nama file gambar
    full_name = fullfile(image_folder, filenames(n).name);

    % Membaca gambar
    I = imread(full_name);

    % Menerapkan filter median ke setiap saluran warna
    R_median = medfilt2(I(:, :, 1));
    G_median = medfilt2(I(:, :, 2));
    B_median = medfilt2(I(:, :, 3));

    % Menggabungkan kembali saluran warna yang sudah difilter
    medianFilteredImg = cat(3, R_median, G_median, B_median);

    % Mengkonversi citra hasil filter median ke ruang warna L*a*b
    cform = makecform('srgb2lab');
    lab_medianFiltered = applycform(medianFilteredImg, cform);

    % Ekstrak channel 'a' dari citra L*a*b
    a = lab_medianFiltered(:,:,2);

    % Menghitung threshold Otsu
    thresholdOtsu = graythresh(a);

    % Menerapkan threshold Otsu
    bw = imbinarize(a, thresholdOtsu);

    % Melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
    bw = imfill(bw, 'holes');
    bw = imopen(bw, strel('disk', 2));
    bw = imclose(bw, strel('disk', 2));

    % Ekstraksi fitur bentuk dari citra hasil segmentasi
    stats = regionprops(bw, 'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');

    % Hitung nilai rata-rata dari setiap fitur
    num_objects = numel(stats);
    sum_area = 0;
    sum_perimeter = 0;
    sum_majorAxisLength = 0;
    sum_minorAxisLength = 0;
    sum_eccentricity = 0;

    for i = 1:num_objects
        sum_area = sum_area + stats(i).Area;
        sum_perimeter = sum_perimeter + stats(i).Perimeter;
        sum_majorAxisLength = sum_majorAxisLength + stats(i).MajorAxisLength;
        sum_minorAxisLength = sum_minorAxisLength + stats(i).MinorAxisLength;
        sum_eccentricity = sum_eccentricity + stats(i).Eccentricity;
    end

    mean_area = sum_area / num_objects;
    mean_perimeter = sum_perimeter / num_objects;
    mean_majorAxisLength = sum_majorAxisLength / num_objects;
    mean_minorAxisLength = sum_minorAxisLength / num_objects;
    mean_eccentricity = sum_eccentricity / num_objects;

    % Simpan nilai rata-rata
    fitur_area(n) = mean_area;
    fitur_perimeter(n) = mean_perimeter;
    fitur_majorAxisLength(n) = mean_majorAxisLength;
    fitur_minorAxisLength(n) = mean_minorAxisLength;
    fitur_eccentricity(n) = mean_eccentricity;

    % Konversi citra hasil median filtering ke dalam ruang warna HSV
    hsv = rgb2hsv(medianFilteredImg);

    % Ekstraksi komponen H, S, dan V dari citra HSV
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = hsv(:,:,3);

    % Ubah nilai background menjadi nol berdasarkan binary mask
    h(~bw) = 0;
    s(~bw) = 0;
    v(~bw) = 0;

    % Hitung statistik tambahan untuk H, S, dan V
    mean_h = mean(h(bw == 1));  % Rata-rata Hue
    mean_s = mean(s(bw == 1));  % Rata-rata Saturation
    mean_v = mean(v(bw == 1));  % Rata-rata Value

    std_h = std(h(bw == 1));    % Deviasi standar Hue
    std_s = std(s(bw == 1));    % Deviasi standar Saturation
    std_v = std(v(bw == 1));    % Deviasi standar Value
    
    % Gabungkan kembali komponen H, S, dan V untuk membentuk citra HSV baru (opsional, jika ingin dilihat)
    hsv = cat(3, h, s, v);
    threshold_hsv = hsv;

    % Simpan nilai rata-rata dan deviasi standar
    fitur_mean_h(n) = mean_h;
    fitur_mean_s(n) = mean_s;
    fitur_mean_v(n) = mean_v;
    fitur_std_h(n) = std_h;
    fitur_std_s(n) = std_s;
    fitur_std_v(n) = std_v;

    % Menghitung LBP dari citra grayscale
    grayscale = rgb2gray(medianFilteredImg);

    % Menggunakan hasil thresholding sebagai masker untuk citra grayscale
    maskedGrayscale = grayscale .* uint8(bw);

    % Ekstraksi fitur LBP dari citra grayscale yang telah dimasker
    lbpFeatures = extractLBPFeatures(maskedGrayscale, 'Upright', false);
    lbpMean = mean(lbpFeatures);  % Mengambil rata-rata dari fitur LBP
    lbpStd = std(lbpFeatures);    % Mengambil standar deviasi dari fitur LBP

    % Simpan nilai LBP
    fitur_lbp_mean(n) = lbpMean;
    fitur_lbp_std(n) = lbpStd;

end

% Membuat matriks fitur dengan menumpuk setiap variabel fitur
input = [fitur_area; fitur_perimeter; fitur_majorAxisLength; fitur_minorAxisLength; fitur_eccentricity;...
         fitur_mean_h; fitur_mean_s; fitur_mean_v;...
         fitur_std_h; fitur_std_s; fitur_std_v;...
         fitur_lbp_mean; fitur_lbp_std];

% Menyusun target berdasarkan nama file gambar
nama_kacang = {'Kacang Arab', 'Kacang Ginkgo', 'Kacang Koro Binong', 'Kacang Pistachio', 'Kacang Tunggak'};

% Mengonversi nama file menjadi indeks target
target = zeros(1, total_images);
for n = 1:total_images
    if contains(filenames(n).name, 'Kacang Arab')
        target(n) = 1;
    elseif contains(filenames(n).name, 'Kacang Ginkgo')
        target(n) = 2;
    elseif contains(filenames(n).name, 'Kacang Koro Binong')
        target(n) = 3;
    elseif contains(filenames(n).name, 'Kacang Pistachio')
        target(n) = 4;
    elseif contains(filenames(n).name, 'Kacang Tunggak')
        target(n) = 5;
    else
        target(n) = 0; % Tidak dikenal
    end
end

% Membuat neural network
net = patternnet([20 16 10]);  % Hidden layers: 20, 14, 12 neurons
net.trainFcn = 'trainbr';  % Menggunakan Bayesian Regularization Backpropagation
net.trainParam.epochs = 1000;  % Maksimal 1000 epoch
net.divideParam.trainRatio = 10;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

% Melatih neural network
[net, tr] = train(net, input, ind2vec(target));

% Memprediksi kelas untuk data latih
output_train = net(input);

% Menampilkan struktur jaringan syaraf tiruan
view(net);

% Mengubah output prediksi dari format one-hot menjadi angka kelas
[~, predicted_train] = max(output_train);

% Mengonversi angka kelas menjadi string berdasarkan nama_kacang
predicted_class_names = nama_kacang(predicted_train);
actual_class_names = nama_kacang(target);

% Menyusun hasil target dan prediksi dalam tabel
HasilTargetPrediksi = table((1:total_images)', actual_class_names', predicted_class_names', ...
                            'VariableNames', {'No', 'Kelas Asli', 'Kelas Prediksi'});

% Menyimpan tabel hasil ke dalam workspace
assignin('base', 'HasilTargetPrediksi', HasilTargetPrediksi);

% Menyimpan model dan confidence_threshold
save('trained_network_backpro70.mat', 'net');

% Menghitung prediksi yang benar
prediksi_benar = sum(predicted_train == target);

% Menghitung akurasi
akurasi = (prediksi_benar / total_images) * 100;

% Menampilkan akurasi dari data latih
fprintf('Akurasi pada DATA LATIH 70 : %.2f%%\n', akurasi);