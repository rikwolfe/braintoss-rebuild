package com.example.braintoss;
//
//import android.util.Log;
//import com.smartdevicelink.proxy.rpc.AudioPassThruCapabilities;
//import com.smartdevicelink.proxy.rpc.enums.AudioType;
//
//import java.io.BufferedInputStream;
//import java.io.BufferedOutputStream;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.io.OutputStream;
//import java.io.RandomAccessFile;
//import java.nio.ByteBuffer;
//import java.nio.ByteOrder;
//import java.nio.ShortBuffer;
//
//public class SdlAudioRecorder {
//    private static final String TAG = SdlAudioRecorder.class.getSimpleName();
//
//    // The for public production this enum should be moved into a separate java file.
//    public enum State {
//        Stopped, Started
//    }
//
//    /** Currently this audio class can only handle pcm data. */
//    private static final long AUDIO_PCM = 1;
//
//    /** Private object to synchronize method calls. */
//    private final Object lock;
//
//    /** Internal state variable used to manage recording transitions. */
//    private State state;
//    /** Internal file stream for data. */
//    private OutputStream stream;
//    /** Internal variable s toring the path to the file. */
//    private File file;
//
//    /* The following variables are needed for wave/pcm data. */
//    private long format;
//
//    private long sampleRate;
//    public long getSampleRate() {
//        return sampleRate;
//    }
//
//    private long bitsPerSample;
//    public long getBitsPerSample() {
//        return bitsPerSample;
//    }
//
//    private long channels;
//    private long blockAlign;
//    private long byteRate;
//    private long dataLength;
//    private long audioLength;
//
//    /* The following variables are needed to perform the amplify operation. */
//    public enum AmplifierMode {
//        None, LiveProcessing, PostProcessing
//    }
//
//    private static final double AMPLIFIER_FACTOR_MAX = 50.0;
//    private static final double AMPLIFIER_INCREASE_STEP = 2.5;
//
//    private AmplifierMode amplifierMode;
//    private double amplifierFactor;
//
//
//
//    /** Private constructor for this class provides the singleton. */
//    public SdlAudioRecorder() {
//        lock = new Object();
//        initVariables();
//    }
//
//    // Initializes the variables to be prepared for audio recording.
//    private void initVariables() {
//        stopAudioStream();
//
//        state = State.Stopped;
//        file = null;
//        format = 0;
//        sampleRate = 0;
//        channels = 0;
//        bitsPerSample = 0;
//        blockAlign = 0;
//        byteRate = 0;
//        dataLength = 0;
//        audioLength = 0;
//        amplifierFactor = 0;
//    }
//
//    /** Returns the current recording state of the instance. */
//    public State getState() {
//        synchronized (lock) {
//            return this.state;
//        }
//    }
//
//    /** Returns the length of the current recording in milliseconds. */
//    public double getAudioMilliseconds() {
//        synchronized (lock) {
//            if (this.state == State.Started) {
//                // The total length of the audio data is needed to calculate the milliseconds out of it.
//                double totalbytes = this.audioLength;
//                // Multiply bits per sample and the sample rate to get bits per second.
//                // Divide by 8 to get bytes. Then divide by 1000 to get milliseconds.
//                // E.g. 16 khz sample rate and 16 bits per sample will be 32 bytes per millisecond.
//                double bytespermillisecond = this.bitsPerSample * this.sampleRate / 8.0 / 1000.0;
//
//                return totalbytes / bytespermillisecond;
//            } else {
//                // Return 0 because we don't have any data.
//                return 0;
//            }
//        }
//    }
//
//    /** Starts the audio recorder with the configured capabilities. */
//    public void startAudioRecording(File file, AmplifierMode mode, AudioPassThruCapabilities capabilities) throws IOException {
//        synchronized (lock) {
//            if (this.state == State.Stopped) {
//                boolean success = false;
//
//                try {
//                    this.channels = 1;
//
//                    if (capabilities != null) {
//                        switch (capabilities.getSamplingRate()) {
//                            case _8KHZ:
//                                this.sampleRate = 8000;
//                                break;
//                            case _16KHZ:
//                                this.sampleRate = 16000;
//                                break;
//                            case _22KHZ:
//                                this.sampleRate = 22000;
//                                break;
//                            case _44KHZ:
//                                this.sampleRate = 44000;
//                            default:
//                                Log.w(TAG, "Unsupported sample rate " + capabilities.getSamplingRate().toString() + " setting to 16 kHz");
//                                this.sampleRate = 16000;
//                                break;
//                        }
//
//                        switch (capabilities.getBitsPerSample()) {
//                            case _8_BIT:
//                                this.bitsPerSample = 8;
//                                break;
//                            case _16_BIT:
//                                this.bitsPerSample = 16;
//                                break;
//                            default:
//                                Log.w(TAG, "Unsupported bps " + capabilities.getBitsPerSample().toString() + " setting to 8 bps");
//                                this.bitsPerSample = 8;
//                                break;
//                        }
//
//                        if (capabilities.getAudioType() != AudioType.PCM) {
//                            Log.w(TAG, "Unsupported audio type " + capabilities.getAudioType().toString() + " setting to PCM");
//                        }
//                    }
//                    else {
//                        this.sampleRate = 16000;
//                        this.bitsPerSample = 16;
//                    }
//
//                    this.format = AUDIO_PCM;
//                    this.blockAlign = (this.channels * this.bitsPerSample) / 8;
//                    this.byteRate = (this.channels * this.bitsPerSample * this.sampleRate) / 8;
//
//                    // temporarily set amplifier factor to max. this helps to find the best factor
//                    amplifierMode = mode;
//                    if (amplifierMode == AmplifierMode.None) {
//                        amplifierFactor = 1;
//                    } else {
//                        amplifierFactor = AMPLIFIER_FACTOR_MAX;
//                    }
//
//                    // almost ready. update the file variable and state. then start the audio stream.
//                    this.file = file;
//                    this.state = State.Started;
//                    this.startAudioStream();
//
//                    // at the end we will use the success bool to indicate if there was an error.
//                    success = true;
//                }
//                finally {
//                    // if starting the audio recoder was not successful we need to reset was we done above.
//                    if (!success) {
//                        this.initVariables();
//                    }
//                }
//            }
//        }
//    }
//
//    /** Finishes the recording of an audio file. This method should be called when AudioPassThru has finished successfuly. */
//    public void finishAudioRecording() throws IOException {
//        synchronized (lock) {
//            if (this.state == State.Started) {
//                try {
//                    stopAudioStream(true);
//
//                    if (amplifierMode == AmplifierMode.PostProcessing) {
//                        this.amplifyAudioFile(this.file);
//                    }
//                }
//                finally {
//                    this.initVariables();
//                }
//            }
//        }
//    }
//
//    /** Aborts the recording of an audio file and deletes all recorded data. */
//    public void cancelAudioRecording() throws IOException {
//        synchronized (lock) {
//            if (this.state == State.Started) {
//                try {
//                    stopAudioStream(false);
//
//                    //noinspection ResultOfMethodCallIgnored
//                    this.file.delete();
//                }
//                finally {
//                    this.initVariables();
//                }
//            }
//        }
//    }
//
//    /** Writes a block of audio data to the audio file. This data should come from the AudioPassThru notification. */
//    public void writeAudioData(byte[] data) throws IOException {
//        synchronized (lock) {
//            if (this.state == State.Started) {
//                boolean success = false;
//                try {
//                    if (amplifierMode == AmplifierMode.LiveProcessing) {
//                        double factor = this.calculateAmplifierFactor(data, data.length);
//                        if (factor > amplifierFactor) {
//                            amplifierFactor = Math.min(Math.min(factor, amplifierFactor + AMPLIFIER_INCREASE_STEP), AMPLIFIER_FACTOR_MAX);
//                        } else {
//                            amplifierFactor = factor;
//                        }
//
//                        applyAmplifierFactor(amplifierFactor, data, data.length);
//                    }
//
//                    this.stream.write(data);
//                    this.dataLength += data.length;
//                    this.audioLength += data.length;
//
//                    RandomAccessFile raf = new RandomAccessFile(this.file, "rw");
//                    this.updateWaveHeaderLength(raf, this.dataLength, this.audioLength);
//                    raf.close();
//
//                    success = true;
//                }
//                finally {
//                    if (!success) {
//                        this.initVariables();
//                    }
//                }
//            }
//        }
//    }
//
//    /** Amplifies the whole audio file based on the calculated amplifier factor. */
//    private void amplifyAudioFile(File file) throws IOException {
//        // amplify the original file into a temp file
//        byte[] header = new byte[44];
//        byte[] data = new byte[1024];
//        int count;
//
//        // create a File object pointing to a temporary file
//        File newfile = new File(file.getParent() + "/tmp-" + file.getName());
//
//        // open original file for read
//        BufferedInputStream istream = new BufferedInputStream(new FileInputStream(file));
//
//        // open temporary file for write
//        BufferedOutputStream ostream = new BufferedOutputStream(new FileOutputStream(newfile));
//
//        // first read the header and write it to the temporary file
//        istream.read(header, 0, header.length);
//        ostream.write(header, 0, header.length);
//
//        // now read data chunks until we are done
//        while ((count = istream.read(data, 0, data.length)) > 0) {
//            // in live processing we can dynamically arrange the amplifier factor
//            double factor = this.calculateAmplifierFactor(data, count);
//            if (factor > amplifierFactor) {
//                amplifierFactor = Math.min(Math.min(factor, amplifierFactor + AMPLIFIER_INCREASE_STEP), AMPLIFIER_FACTOR_MAX);
//            } else {
//                amplifierFactor = factor;
//            }
//
//            applyAmplifierFactor(amplifierFactor, data, count);
//
//            // amplifier factor applied now write it to the temporary file
//            ostream.write(data, 0, count);
//        }
//
//        // all audio data is amplified. close the streams
//        ostream.flush();
//        ostream.close();
//        istream.close();
//
//        // now delete the original file
//        file.delete();
//        // now rename the temporary file to the original file
//        newfile.renameTo(file);
//    }
//
//    /**
//     * Applies the amplifier factor to the block of audio data.
//     * @param factor the amplification factor to be applied to each sample.
//     * @param bytedata A memory area which stores the samples.
//     * @param size The size in bytes of the memory area to amplify.
//     *             This is useful when reusing a buffer as the memory area.
//     */
//    private void applyAmplifierFactor(double factor, byte[] bytedata, int size) {
//        if (factor == 1.0) {
//            return;
//        }
//
//        if (this.bitsPerSample == 16) {
//            // divide count to short elements
//            size = size >> 1;
//
//            // create byte buffer
//            ByteBuffer byteBuffer = ByteBuffer.wrap(bytedata).order(ByteOrder.LITTLE_ENDIAN);
//            ShortBuffer shortBuffer = byteBuffer.asShortBuffer();
//
//            // loop through all samples
//            for (int i = 0; i < size; i++) {
//                short a = shortBuffer.get(i);
//                // apply the amplifier factor with best precision and round it
//                a = (short) (Math.round(((double) a) * factor));
//                // write the amplified sample value back to the buffer
//                shortBuffer.put(i, a);
//            }
//        } else {
//            // loop through all samples
//            for (int i = 0; i < size; i++) {
//                // get the sample value
//                byte a = bytedata[i];
//                // apply the amplifier factor with best precision and round it
//                a = (byte) (Math.round(((double) a) * factor));
//                // write the amplified sample value back to the buffer
//                bytedata[i] = a;
//            }
//        }
//    }
//
//    /** Calculates the best amplifier factor for the audio chunk. */
//    private double calculateAmplifierFactor(byte[] bytedata, int size) {
//        double factor = AMPLIFIER_FACTOR_MAX;
//
//        if (this.bitsPerSample == 16) {
//            int count = size >> 1;
//
//            // create byte buffer
//            ByteBuffer byteBuffer = ByteBuffer.wrap(bytedata).order(ByteOrder.LITTLE_ENDIAN);
//            ShortBuffer shortBuffer = byteBuffer.asShortBuffer();
//
//            for (int i = 0; i < count; i++) {
//                short a = shortBuffer.get(i);
//                double f;
//                if (a >= 0) {
//                    f = ((double)Short.MAX_VALUE) / ((double)a);
//                } else {
//                    f = ((double)Short.MIN_VALUE) / ((double)a);
//                }
//
//                factor = Math.min(factor, f);
//            }
//        } else {
//            for (int i = 0; i < size; i++) {
//                byte a = bytedata[i];
//                double f;
//                if (a >= 0) {
//                    f = ((double)Byte.MAX_VALUE) / ((double)a);
//                } else {
//                    f = ((double)Byte.MIN_VALUE) / ((double)a);
//                }
//
//                factor = Math.min(factor, f);
//            }
//        }
//
//        return factor;
//    }
//
//    /** Starts the stream to the audio file and writes the initial header. */
//    private void startAudioStream() throws IOException {
//        this.stream = new BufferedOutputStream(new FileOutputStream(this.file));
//
//        this.dataLength = 36;
//        this.audioLength = 0;
//
//        this.writeWaveHeader(this.stream, this.dataLength, this.audioLength, this.format, this.sampleRate, this.bitsPerSample, this.channels, this.blockAlign,
//                this.byteRate);
//    }
//
//    private void stopAudioStream() {
//        stopAudioStream(false);
//    }
//
//    private void stopAudioStream(boolean flush) {
//        if (stream != null) {
//            if (flush) {
//                try {
//                    stream.flush();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//            try {
//                stream.close();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//        stream = null;
//    }
//
//    /**
//     * Writes a RIFF/WAVE header to the stream
//     * @param format Use 1 for PCM recording
//     * @param blockalign Use (channels * bitspersample) / 8 for PCM recording
//     * @param byterate Use (samplerate * channels * bitspersample) / 8 for PCM recording
//     */
//    private void writeWaveHeader(OutputStream stream, long datalength, long audiolength, long format, long samplerate, long bitspersample, long channels,
//                                 long blockalign, long byterate) throws IOException {
//        byte[] header = new byte[44];
//
//        // RIFF header.
//        header[0] = 'R';
//        header[1] = 'I';
//        header[2] = 'F';
//        header[3] = 'F';
//        // Total data length (UInt32).
//        header[4] = (byte)((datalength) & 0xff);
//        header[5] = (byte)((datalength >> 8) & 0xff);
//        header[6] = (byte)((datalength >> 16) & 0xff);
//        header[7] = (byte)((datalength >> 24) & 0xff);
//        // WAVE header.
//        header[8] = 'W';
//        header[9] = 'A';
//        header[10] = 'V';
//        header[11] = 'E';
//        // Format (fmt) header.
//        header[12] = 'f';
//        header[13] = 'm';
//        header[14] = 't';
//        header[15] = ' ';
//        // Format header size (UInt32).
//        header[16] = 16;
//        header[17] = 0;
//        header[18] = 0;
//        header[19] = 0;
//        // Format type (UInt16). Set 1 for PCM.
//        header[20] = (byte)((format) & 0xff);
//        header[21] = (byte)((format >> 8) & 0xff);
//        // Channels
//        header[22] = (byte)((channels) & 0xff);
//        header[23] = (byte)((channels >> 8) & 0xff);
//        // Sample rate (UInt32).
//        header[24] = (byte)((samplerate) & 0xff);
//        header[25] = (byte)((samplerate >> 8) & 0xff);
//        header[26] = (byte)((samplerate >> 16) & 0xff);
//        header[27] = (byte)((samplerate >> 24) & 0xff);
//        // Byte rate (UInt32).
//        header[28] = (byte)((byterate) & 0xff);
//        header[29] = (byte)((byterate >> 8) & 0xff);
//        header[30] = (byte)((byterate >> 16) & 0xff);
//        header[31] = (byte)((byterate >> 24) & 0xff);
//        // Block alignment (UInt16).
//        header[32] = (byte)((blockalign) & 0xff);
//        header[33] = (byte)((blockalign >> 8) & 0xff);
//        // Bits per sample (UInt16).
//        header[34] = (byte)((bitspersample) & 0xff);
//        header[35] = (byte)((bitspersample >> 8) & 0xff);
//        // Data header
//        header[36] = 'd';
//        header[37] = 'a';
//        header[38] = 't';
//        header[39] = 'a';
//        // Total audio length (UInt32).
//        header[40] = (byte)((audiolength) & 0xff);
//        header[41] = (byte)((audiolength >> 8) & 0xff);
//        header[42] = (byte)((audiolength >> 16) & 0xff);
//        header[43] = (byte)((audiolength >> 24) & 0xff);
//
//        stream.write(header, 0, header.length);
//    }
//
//    /** Updates the data length and audio length of an existing RIFF/WAVE header in the file pointed by the RandomAccessFile object. */
//    private void updateWaveHeaderLength(RandomAccessFile stream, long datalength, long audiolength) throws IOException {
//        // Seek from the beginning to data length
//        stream.seek(4);
//        // Overwrite total data length
//        stream.write((int)((datalength) & 0xff));
//        stream.write((int)((datalength >> 8) & 0xff));
//        stream.write((int)((datalength >> 16) & 0xff));
//        stream.write((int)((datalength >> 24) & 0xff));
//        // Seek from the end of data length to audio length
//        stream.seek(40);
//        // overwrite total audio length
//        stream.write((int)((audiolength) & 0xff));
//        stream.write((int)((audiolength >> 8) & 0xff));
//        stream.write((int)((audiolength >> 16) & 0xff));
//        stream.write((int)((audiolength >> 24) & 0xff));
//    }
//}
