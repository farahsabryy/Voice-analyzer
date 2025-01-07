function voiceCapture
    % Create GUI
    fig = figure('Name',  'Voice Capture GUI', 'NumberTitle', 'off', 'Position', [100, 100, 500, 300]);

    % UI components
    uicontrol('Style', 'text', 'String', 'Max Time (s):', 'Position', [10, 250, 80, 20]);
    maxTimeEdit = uicontrol('Style', 'edit', 'Position', [100, 250, 50, 20]);

    uicontrol('Style', 'text', 'String', 'Sampling Freq (Hz):', 'Position', [180, 250, 100, 20]);
    samplingFreqEdit = uicontrol('Style', 'edit', 'Position', [290, 250, 50, 20]);
    
    uicontrol('Style', 'text', 'String', 'Min T(s):', 'Position', [10, 200, 100, 20]);
    minEdit=uicontrol('Style', 'edit', 'Position', [100, 200, 50, 20]);
     
    uicontrol('Style', 'text', 'String', 'Max T(s):', 'Position', [180, 200, 100, 20]);
    maxEdit=uicontrol('Style', 'edit', 'Position', [290, 200, 50, 20]);
    
    uicontrol('Style', 'text', 'String', 'Min F(Hz):', 'Position', [10, 150, 100, 20]);
    minnEdit=uicontrol('Style', 'edit', 'Position', [100, 150, 50, 20])   
    uicontrol('Style', 'text', 'String', 'Max F(Hz):', 'Position', [180, 150, 100, 20]);
    maxxEdit=uicontrol('Style', 'edit', 'Position', [290, 150, 50, 20]);
    
    
    startButton = uicontrol('Style', 'pushbutton', 'String', 'Start', 'Position', [50,95, 100, 30], 'Callback', @startCapture);
    stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop', 'Position', [200,95, 100, 30], 'Callback', @stopCapture);
    
    playButton = uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [350, 95, 100, 30], 'Callback', @playSignal);

    % Variables 
    recorder = [];
    voiceSignal = [];
    Fs=0;
    min=0;
    max=0;
    minn=0;
    maxx=0;
    stopButtonPressed = false;
    
    % Callback functions
    
    
    function startCapture(~, ~)
        % Retrieve inputs
       
        Tmax = str2double(get(maxTimeEdit, 'String'));
        Fs = str2double(get(samplingFreqEdit, 'String'));
        
            
        % Create audiorecorder object
        recorder = audiorecorder(Fs, 16, 1);
        
        stopButtonPressed = false;

        % Record voice for Tmax seconds
        record(recorder, Tmax);

        % Wait for recording to complete
        
        for t = 1:Tmax
            if stopButtonPressed
                % Stop the recorder and exit the loop
                stop(recorder);
                break;
            end
            % Pause for 1 second
            pause(1);
        end

        % Get recorded voice signal
        
        voiceSignal = getaudiodata(recorder);

        % Display voice signal in time domain
        displayTimeDomain(voiceSignal, Fs);

    end

    function stopCapture(~, ~)
        % Stop the recorder
        stopButtonPressed=true;
        stop(recorder);
        
        % Get recorded voice signal
        voiceSignal = getaudiodata(recorder);
        
        % Display voice signal in time domain
        displayTimeDomain(voiceSignal, Fs);

       
    end
    
    function playSignal(~, ~)
        % Play the recorded signal
        sound(voiceSignal, Fs);
    end

    function displayTimeDomain(signal, Fs)
        % Display voice signal in time domain
        min = str2double(get(minEdit, 'String'));
        max = str2double(get(maxEdit, 'String'));
        minn = str2double(get(minnEdit, 'String'));
        maxx =str2double(get(maxxEdit, 'String'));
        time = (0:length(signal)-1) / Fs;
        figure('Name', 'Plotting Table', 'NumberTitle', 'off');
        subplot(411);
        plot(time, signal);
        xlim([min max]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('Voice Signal in Time Domain');
        grid on;
        
        % Display voice signal in frequency domain nd plots the amplitude
        % of the signal
        N = length(signal);
        Y = fft(signal);
        f = Fs * (0:(N/2))/N;
        Z=((1/Fs)*Y);
        P = abs((1/Fs)*Y); 
        subplot(412);
        plot(f, P(1:N/2+1));
        xlim([minn maxx]);
        title('Voice Signal in Frequency Domain');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        grid on;
        
        %plots the phase of the signal
        subplot(413);
        plot(f, angle(Z(1:N/2+1)));   
        title('Phase');
        xlabel('Frequency (Hz)');
        ylabel('Phase');
        grid on;
        
        %plots energy
        subplot(414);
        plot(f, (P(1:N/2+1)).^2);
        xlim([minn maxx]);
        title('Energy Spectrum');
        xlabel('Frequency (Hz)');
        ylabel('Energy');
        grid on;
           
    end
end
