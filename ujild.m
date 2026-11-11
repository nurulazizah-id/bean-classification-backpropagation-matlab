clc; clear; close all; warning off all;

% Load model yang telah dilatih
load('trained_network_backpro80.mat', 'net');

% Inisialisasi folder citra uji
test_image_folder = 'D:\programskripsi\pengujianld150';
test_filenames = dir(fullfile(test_image_folder, '*.jpg'));
total_test_images = numel(test_filenames);

% Inisialisasi array untuk menyimpan fitur-fitur citra uji
fitur_area = zeros(1, total_test_images);
fitur_perimeter = zeros(1, total_test_images);
fitur_majorAxisLength = zeros(1, total_test_images);
fitur_minorAxisLength = zeros(1, total_test_images);
fitur_eccentricity = zeros(1, total_test_images);
fitur_mean_h = zeros(1, total_test_images);  % Rata-rata Hue
fitur_mean_s = zeros(1, total_test_images);  % Rata-rata Saturation
fitur_mean_v = zeros(1, total_test_images);  % Rata-rata Value
fitur_std_h = zeros(1, total_test_images);   % Deviasi standar Hue
fitur_std_s = zeros(1, total_test_images);   % Deviasi standar Saturation
fitur_std_v = zeros(1, total_test_images);   % Deviasi standar Value
fitur_lbp_mean = zeros(1, total_test_images);
fitur_lbp_std = zeros(1, total_test_images);

% Menghitung fitur-fitur untuk setiap citra uji
for n = 1:total_test_images
    % Mendapatkan nama file gambar
    full_name = fullfile(test_image_folder, test_filenames(n).name);

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
    % figure, imshow(bw);
    
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
input_test = [fitur_area; fitur_perimeter; fitur_majorAxisLength; fitur_minorAxisLength; fitur_eccentricity;...
              fitur_mean_h; fitur_mean_s; fitur_mean_v;...
              fitur_std_h; fitur_std_s; fitur_std_v;...
              fitur_lbp_mean; fitur_lbp_std];
          
% Menyusun target berdasarkan indeks
target_test = zeros(1, total_test_images);
target_test(1:30)    = 1; % Arab 
target_test(31:60)   = 2; % Ginkgo 
target_test(61:90)   = 3; % Koro Pedang
target_test(91:120)  = 4; % Pistachio
target_test(121:150) = 5; % Tunggak

% Menentukan threshold untuk setiap fitur
max_thresholds = [7865, 325.0280, 120.3331, 85.4542, 0.8598, 0.4797, 0.2354, 0.8909, 0.3228, 0.2529, 0.2374, 0.1094, 0.3142]; % Batas maksimum
min_thresholds = [4427, 242.7400, 83.5353, 53.5346, 0.4726, 0.1018, 0.0311, 0.7113, 0.0433, 0.0392, 0.0729, 0.1057, 0.3127]; % Batas minimum

% Inisialisasi prediksi kelas
predicted_class = zeros(1, total_test_images);

% Proses pengenalan objek dan klasifikasi
for n = 1:total_test_images
    fitur_input = input_test(:, n);

    % Logika Max-Min untuk pengenalan objek berdasarkan fitur ekstraksi
    is_known = true;  % Inisialisasi status pengenalan objek
    for i = 1:length(fitur_input)
        if fitur_input(i) > max_thresholds(i) || fitur_input(i) < min_thresholds(i)
            is_known = false;
            break;
        end
    end

    % Jika objek dikenal berdasarkan fitur, lakukan prediksi dengan neural network
    if is_known
        % Menggunakan model untuk memprediksi
        output = net(fitur_input);
        [confidence_value, predicted_label] = max(output);

        % Menentukan nama kelas hasil prediksi
        switch predicted_label
            case 1
                kelas = 'Kacang Arab';
            case 2
                kelas = 'Kacang Ginkgo';
            case 3
                kelas = 'Kacang Koro Pedang';
            case 4
                kelas = 'Kacang Pistachio';
            case 5
                kelas = 'Kacang Tunggak'; 
            otherwise
                kelas = 'TIDAK DIKENALI';
        end
        predicted_class(n) = predicted_label; % Simpan prediksi kelas
    else
        kelas = 'TIDAK DIKENALI';
        predicted_class(n) = 6; % Tidak dikenal
    end
end

% Menghitung jumlah citra yang benar diklasifikasikan sebagai 'TIDAK DIKENALI'
benar_tidak_dikenali = sum(predicted_class == 6);

% Menghitung akurasi
akurasi_test = (benar_tidak_dikenali / total_test_images) * 100;

% Menampilkan akurasi dari data uji
fprintf('Akurasi pada DILUAR DATASET: %.2f%%\n', akurasi_test);

% Mengkonversi angka kelas ke nama kelas
nama_kelas = {'Kacang Arab', 'Kacang Ginkgo', 'Kacang Koro Pedang', 'Kacang Pistachio', 'Kacang Tunggak', 'Tidak Dikenali'};
nama_kelas_aktual = {test_filenames.name} ;
nama_kelas_prediksi = nama_kelas(predicted_class);

% Menyusun tabel hasil dengan nama kelas
tabel_hasil = table((1:total_test_images)', nama_kelas_aktual', nama_kelas_prediksi', ...
    'VariableNames', {'NomorGambar', 'KelasAktual', 'KelasPrediksi'});

% Menyimpan tabel hasil ke workspace
assignin('base', 'tabel_hasil', tabel_hasil);

% Menyesuaikan target dan prediksi menjadi kategori dengan nama kelas
target = categorical(target_test, 1:6, nama_kelas);
predicted_test = categorical(predicted_class, 1:6, nama_kelas);

% Membuat confusion matrix
cm = confusionmat(target, predicted_test);

% Menampilkan confusion matrix menggunakan confusionchart
figure;
confMatChart = confusionchart(cm, nama_kelas, ...
    'RowSummary', 'row-normalized', ...
    'ColumnSummary', 'column-normalized');
title('Test Confusion Matrix');
