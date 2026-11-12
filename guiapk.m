function varargout = guiapk(varargin)
%GUIAPK MATLAB code file for guiapk.fig
%      GUIAPK, by itself, creates a new GUIAPK or raises the existing
%      singleton*.
%
%      H = GUIAPK returns the handle to a new GUIAPK or the handle to
%      the existing singleton*.
%
%      GUIAPK('Property','Value',...) creates a new GUIAPK using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to guiapk_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUIAPK('CALLBACK') and GUIAPK('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUIAPK.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiapk

% Last Modified by GUIDE v2.5 24-Jul-2024 07:20:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiapk_OpeningFcn, ...
                   'gui_OutputFcn',  @guiapk_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before guiapk is made visible.
function guiapk_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for guiapk
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes guiapk wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Inisialisasi current_image_index
handles.current_image_index = 1; % Misalnya, jika Anda ingin memulai dari gambar pertama

% Menyimpan data pada handles
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guiapk_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Membuka dialog untuk memilih gambar
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Pilih gambar');
 
if ~isequal(filename, 0)
    % Membaca gambar
    img = imread(fullfile(pathname, filename));
    
    % Menampilkan gambar di axes1
    axes(handles.axes1);
    imshow(img);
    
    % Menyimpan gambar di variabel handles untuk digunakan di fungsi lain
    handles.img = img;
    guidata(hObject, handles);
    
else
    % Menampilkan pesan kesalahan jika pemilihan gambar dibatalkan
    errordlg('Pemilihan gambar dibatalkan.', 'Error');
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memastikan gambar telah dimuat sebelumnya
if isfield(handles, 'img')
    % Mengambil gambar dari variabel handles
    img = handles.img;
    
    % Menerapkan filter median ke setiap saluran warna
    R_median = medfilt2(img(:, :, 1));
    G_median = medfilt2(img(:, :, 2));
    B_median = medfilt2(img(:, :, 3));
    
    % Menggabungkan kembali saluran warna yang sudah difilter
    medianFilteredImg = cat(3, R_median, G_median, B_median);
    
    % Menampilkan gambar hasil filter median
    axes(handles.axes2);
    imshow(medianFilteredImg);
    
    % Simpan gambar hasil filter median di variabel handles untuk digunakan di fungsi lain
    handles.medianFilteredImg = medianFilteredImg;
    guidata(hObject, handles);
    
else
    % Tampilkan pesan kesalahan jika gambar belum dimuat
    errordlg('Mohon Input Citra terlebih dahulu.', 'Error');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memeriksa apakah field 'medianFilteredImg' ada di dalam handles
if isfield(handles, 'medianFilteredImg')
    % Mengambil gambar hasil filter median dari variabel handles
    img = handles.img;
    medianFilteredImg = handles.medianFilteredImg;

    % Konversi gambar hasil filter median ke grayscale
    grayscale = rgb2gray(medianFilteredImg);
    
    % Tampilkan citra grayscale pada axes yang sesuai
    axes(handles.axes3) 
    imshow(grayscale)
    
    % Simpan citra grayscale pada handles
    handles.grayscale = grayscale;
    guidata(hObject, handles);
else
    % Menampilkan pesan kesalahan jika citra hasil filter median tidak tersedia di handles
    errordlg('Citra hasil filter median tidak ditemukan.', 'Error');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memeriksa apakah field 'medianFilteredImg' ada di dalam handles
if isfield(handles, 'medianFilteredImg')
    % Mengambil gambar hasil filter median dari variabel handles
    img = handles.img;
    medianFilteredImg = handles.medianFilteredImg;

    % Mengkonversi citra hasil filter median ke ruang warna L*a*b
    cform = makecform('srgb2lab');
    lab_medianFiltered = applycform(medianFilteredImg, cform);

    % Menyimpan variabel lab pada lokasi handles agar dapat dipanggil oleh pushbutton yang lain
    handles.lab_medianFiltered = lab_medianFiltered;

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

    % Menampilkan citra hasil segmentasi pada axes
    axes(handles.axes4)
    imshow(bw)
    
    % Simpan variabel bw pada lokasi handles agar dapat dipanggil oleh pushbutton lainnya
    handles.bw = bw;
    guidata(hObject, handles);
    
else
    % Menampilkan pesan kesalahan jika citra hasil filter median tidak tersedia di handles
    errordlg('Citra hasil filter median tidak ditemukan.', 'Error');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Periksa apakah variabel handles.medianFilteredImg dan handles.bw sudah diinisialisasi
if isfield(handles, 'medianFilteredImg') 
    % Ambil citra dan citra hasil median filtering dari handles
    img = handles.img;
    medianFilteredImg = handles.medianFilteredImg;
    lab_medianFiltered = handles.lab_medianFiltered;
    bw = handles.bw;

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
    
    % Gabungkan kembali komponen H, S, dan V untuk membentuk citra HSV baru (opsional, jika ingin dilihat)
    hsv = cat(3, h, s, v);
    threshold_hsv = hsv; 
    
   % Tampilkan citra di axes 5
    axes(handles.axes5);
    imshow(threshold_hsv);

    % Simpan citra dalam ruang warna HSV setelah modifikasi dengan binary mask
    handles.threshold_hsv = hsv;
    % Perbarui handles dalam data GUI
    guidata(hObject, handles);
else
    % Tampilkan pesan kesalahan jika citra hasil filter median tidak ditemukan di dalam variabel handles
    errordlg('Citra hasil filter median tidak ditemukan.', 'Error');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Pastikan bidang 'bw' ada di dalam variabel handles
% Pastikan bidang 'bw' ada di dalam variabel handles
if isfield(handles, 'bw')
    img = handles.img;
    medianFilteredImg = handles.medianFilteredImg;
    lab_medianFiltered = handles.lab_medianFiltered;
    bw = handles.bw; % Mengambil hasil segmentasi
    
    % Ekstraksi fitur dari citra hasil segmentasi
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

    % Menyimpan nilai rata-rata pada handles untuk digunakan nanti
    handles.fitur_area = mean_area;
    handles.fitur_perimeter = mean_perimeter;
    handles.fitur_majorAxisLength = mean_majorAxisLength;
    handles.fitur_minorAxisLength = mean_minorAxisLength;
    handles.fitur_eccentricity = mean_eccentricity;
    guidata(hObject, handles);

    % Menampilkan nilai-nilai fitur pada edit text 
    set(handles.edit6, 'String', num2str(mean_area));
    set(handles.edit7, 'String', num2str(mean_perimeter));
    set(handles.edit8, 'String', num2str(mean_majorAxisLength));
    set(handles.edit9, 'String', num2str(mean_minorAxisLength));
    set(handles.edit10,'String', num2str(mean_eccentricity));
else
    % Jika bidang 'bw' tidak ada di dalam variabel handles
    errordlg('Citra bw tidak ditemukan.', 'Error');
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memeriksa apakah bidang 'threshold_hsv' dan 'bw' ada di dalam handles
if isfield(handles, 'threshold_hsv') && isfield(handles, 'bw')
    % Ambil komponen Hue, Saturation, dan Value dari handles
    h = handles.threshold_hsv(:,:,1);
    s = handles.threshold_hsv(:,:,2);
    v = handles.threshold_hsv(:,:,3);
    bw = handles.bw;

    % Hitung nilai Hue, Saturation, dan Value berdasarkan binary mask
    h_masked = h(bw == 1);  % hanya ambil nilai H di area yang di-segmentasi
    s_masked = s(bw == 1);  % hanya ambil nilai S di area yang di-segmentasi
    v_masked = v(bw == 1);  % hanya ambil nilai V di area yang di-segmentasi

    % Hitung rata-rata dan deviasi standar
    mean_h = mean(h_masked);  % rata-rata Hue
    mean_s = mean(s_masked);  % rata-rata Saturation
    mean_v = mean(v_masked);  % rata-rata Value
    std_h = std(h_masked);    % deviasi standar Hue
    std_s = std(s_masked);    % deviasi standar Saturation
    std_v = std(v_masked);    % deviasi standar Value

    % Simpan nilai rata-rata dan deviasi standar
    handles.fitur_mean_h = mean_h;
    handles.fitur_mean_s = mean_s;
    handles.fitur_mean_v = mean_v;
    handles.fitur_std_h = std_h;
    handles.fitur_std_s = std_s;
    handles.fitur_std_v = std_v;
    guidata(hObject, handles);

    % Tampilkan hasilnya pada edit text
    set(handles.edit17, 'String', num2str(mean_h));
    set(handles.edit18, 'String', num2str(mean_s));
    set(handles.edit19, 'String', num2str(mean_v));
    set(handles.edit20, 'String', num2str(std_h));  % Edit text untuk deviasi standar Hue
    set(handles.edit21, 'String', num2str(std_s));  % Edit text untuk deviasi standar Saturation
    set(handles.edit22, 'String', num2str(std_v));  % Edit text untuk deviasi standar Value

else
    % Menampilkan pesan kesalahan jika bidang 'threshold_hsv' tidak ada di dalam variabel handles
    errordlg('Citra threshold_hsv atau binary mask tidak ditemukan.', 'Error');
end

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Memeriksa keberadaan fitur di dalam handles

% Memeriksa keberadaan fitur di dalam handles
if isfield(handles, 'fitur_area') && isfield(handles, 'fitur_perimeter') && ...
        isfield(handles, 'fitur_majorAxisLength') && isfield(handles, 'fitur_minorAxisLength') && ...
        isfield(handles, 'fitur_eccentricity') && isfield(handles, 'fitur_mean_h') && ...
        isfield(handles, 'fitur_mean_s') && isfield(handles, 'fitur_mean_v') && ...
        isfield(handles, 'fitur_std_h') && isfield(handles, 'fitur_std_s') && ...
        isfield(handles, 'fitur_std_v') && isfield(handles, 'fitur_lbp_mean') && ...
        isfield(handles, 'fitur_lbp_std')

    % Ambil fitur-fitur dari handles
    fitur_area = handles.fitur_area; 
    fitur_perimeter = handles.fitur_perimeter; 
    fitur_majorAxisLength = handles.fitur_majorAxisLength; 
    fitur_minorAxisLength = handles.fitur_minorAxisLength; 
    fitur_eccentricity = handles.fitur_eccentricity; 
    fitur_mean_h = handles.fitur_mean_h; 
    fitur_mean_s = handles.fitur_mean_s; 
    fitur_mean_v = handles.fitur_mean_v; 
    fitur_std_h = handles.fitur_std_h; 
    fitur_std_s = handles.fitur_std_s; 
    fitur_std_v = handles.fitur_std_v; 
    fitur_lbp_mean = handles.fitur_lbp_mean;
    fitur_lbp_std = handles.fitur_lbp_std;

   % Gabungkan fitur-fitur tersebut ke dalam matriks input
   fitur_input = [fitur_area; fitur_perimeter; fitur_majorAxisLength; fitur_minorAxisLength; ...
            fitur_eccentricity; fitur_mean_h; fitur_mean_s; fitur_mean_v; ...
            fitur_std_h; fitur_std_s; fitur_std_v; fitur_lbp_mean; fitur_lbp_std];
        
   % Menentukan threshold untuk setiap fitur
    max_thresholds = [7865, 325.0280, 120.3331, 86.8765, 0.8598, 0.4797, 0.2354, 0.8909, 0.3228, 0.2529, 0.2374, 0.1094, 0.3142]; % Batas maksimum
    min_thresholds = [4427, 242.7400, 83.5353, 55.5346, 0.4726, 0.1018, 0.0311, 0.7113, 0.0433, 0.0392, 0.0729, 0.1057, 0.3127]; % Batas minimum
    
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
        % Load model yang telah dilatih
        load('trained_network_backpro80.mat', 'net');
        
        % Menggunakan model untuk memprediksi
        output = net(fitur_input);
        [confidence_value, predicted_label] = max(output);
        
        % Menentukan kelas hasil prediksi
        switch predicted_label
            case 1
                kelas = 'Kacang Arab';
            case 2
                kelas = 'Kacang Ginkgo';
            case 3
                kelas = 'Kacang Koro Binong';
            case 4
                kelas = 'Kacang Pistachio';
            case 5
                kelas = 'Kacang Tunggak';
            otherwise
                kelas = 'TIDAK DIKENALI';
        end
        
        % Tampilkan hasil prediksi di GUI
        set(handles.edit27, 'String', kelas);
    else
        % Jika tidak dikenal, tampilkan 'TIDAK DIKENALI'
        set(handles.edit27, 'String', 'TIDAK DIKENALI');
    end
else
    % Tampilkan pesan kesalahan jika fitur bentuk atau warna tidak tersedia di dalam variabel handles
    errordlg('Fitur bentuk, warna, dan tekstur tidak ditemukan.', 'Error');
end

function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
axes(handles.axes6)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
set(handles.edit6,'String',' ')
set(handles.edit7,'String',' ')
set(handles.edit8,'String',' ')
set(handles.edit9,'String',' ')
set(handles.edit10,'String',' ')
set(handles.edit17,'String',' ')
set(handles.edit18,'String',' ')
set(handles.edit19,'String',' ')
set(handles.edit20,'String',' ')
set(handles.edit21,'String',' ')
set(handles.edit22,'String',' ')
set(handles.edit25,'String',' ')
set(handles.edit26,'String',' ')
set(handles.edit27,'String',' ')
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memeriksa apakah field 'maskedGrayscale' ada di dalam handles
if isfield(handles, 'maskedGrayscale')
    % Mengambil citra masked grayscale dari variabel handles
    maskedGrayscale = handles.maskedGrayscale;

    % Ekstraksi fitur LBP dari citra grayscale yang telah dimasker
    lbpFeatures = extractLBPFeatures(maskedGrayscale, 'Upright', false);
    lbpMean = mean(lbpFeatures);  % Mengambil rata-rata dari fitur LBP
    lbpStd = std(lbpFeatures);    % Mengambil standar deviasi dari fitur LBP

    % Tampilkan LBP mean dan std pada Edit Text
    set(handles.edit25, 'String', num2str(lbpMean));
    set(handles.edit26, 'String', num2str(lbpStd));
    
    % Simpan LBP mean dan std pada handles
    handles.fitur_lbp_mean = lbpMean;
    handles.fitur_lbp_std = lbpStd;
    guidata(hObject, handles);
else
    % Menampilkan pesan kesalahan jika citra masked grayscale tidak tersedia di handles
    errordlg('Citra masked grayscale tidak ditemukan.', 'Error');
end

function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Memeriksa apakah field 'grayscale' dan 'bw' ada di dalam handles
if isfield(handles, 'grayscale') && isfield(handles, 'bw')
    % Mengambil citra grayscale dan binary mask dari variabel handles
    grayscale = handles.grayscale;
    bw = handles.bw;

    % Menggunakan hasil thresholding sebagai masker untuk citra grayscale
    maskedGrayscale = grayscale .* uint8(bw);

    % Simpan citra masked grayscale pada lokasi handles agar dapat dipanggil oleh pushbutton yang lain
    handles.maskedGrayscale = maskedGrayscale;
    guidata(hObject, handles);
    
    % Tampilkan citra hasil segmentasi pada axes
    axes(handles.axes6);
    imshow(maskedGrayscale);
else
    % Menampilkan pesan kesalahan jika citra grayscale atau binary mask tidak tersedia di handles
    errordlg('Citra grayscale atau binary mask tidak ditemukan.', 'Error');
end

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double

% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
