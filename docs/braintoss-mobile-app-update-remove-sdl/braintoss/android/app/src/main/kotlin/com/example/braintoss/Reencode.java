package com.example.braintoss;

import android.media.MediaCodec;
import android.media.MediaCodecInfo;
import android.media.MediaFormat;
import android.media.MediaMuxer;
import android.util.Log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;

public class Reencode implements Runnable {
    private static final String LOGTAG = "Encode";
    public static final String COMPRESSED_AUDIO_FILE_MIME_TYPE = "audio/mp4a-latm";
    public static final int COMPRESSED_AUDIO_FILE_BIT_RATE = 128000; // 128kbps
    public static final int SAMPLING_RATE = 22000;
    public static final int CODEC_TIMEOUT_IN_MS = 5000;
    public static final int BUFFER_SIZE = 88200;

    private final InputStream fis;
    private final File outputFile;

    public Reencode(InputStream is, File outputFile) {
        fis = is;
        this.outputFile = outputFile;
    }

    @Override
    public void run() {
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_BACKGROUND);

        MediaMuxer mux = null;
        MediaCodec codec = null;

        try {
            if (outputFile.exists()) outputFile.delete();

            mux = new MediaMuxer(outputFile.getAbsolutePath(), MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4);

            MediaFormat outputFormat = MediaFormat.createAudioFormat(COMPRESSED_AUDIO_FILE_MIME_TYPE,
                    SAMPLING_RATE, 1);
            outputFormat.setInteger(MediaFormat.KEY_AAC_PROFILE, MediaCodecInfo.CodecProfileLevel.AACObjectLC);
            outputFormat.setInteger(MediaFormat.KEY_BIT_RATE, COMPRESSED_AUDIO_FILE_BIT_RATE);

            codec = MediaCodec.createEncoderByType(COMPRESSED_AUDIO_FILE_MIME_TYPE);
            codec.configure(outputFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE);
            codec.start();

            ByteBuffer[] codecInputBuffers = codec.getInputBuffers(); // Array of buffers
            ByteBuffer[] codecOutputBuffers = codec.getOutputBuffers();

            MediaCodec.BufferInfo outBuffInfo = new MediaCodec.BufferInfo();

            byte[] tempBuffer = new byte[BUFFER_SIZE];
            boolean hasMoreData = true;
            double presentationTimeUs = 0;
            int audioTrackIdx = 0;
            int totalBytesRead = 0;

            do {
                int inputBufIndex = 0;
                while (inputBufIndex != -1 && hasMoreData) {
                    inputBufIndex = codec.dequeueInputBuffer(CODEC_TIMEOUT_IN_MS);

                    if (inputBufIndex >= 0) {
                        ByteBuffer dstBuf = codecInputBuffers[inputBufIndex];
                        dstBuf.clear();

                        int bytesRead = fis.read(tempBuffer, 0, dstBuf.limit());
                        if (bytesRead == -1) { // -1 implies EOS
                            hasMoreData = false;
                            codec.queueInputBuffer(inputBufIndex, 0, 0, (long) presentationTimeUs, MediaCodec.BUFFER_FLAG_END_OF_STREAM);
                        } else {
                            totalBytesRead += bytesRead;
                            dstBuf.put(tempBuffer, 0, bytesRead);
                            codec.queueInputBuffer(inputBufIndex, 0, bytesRead, (long) presentationTimeUs, 0);
                            presentationTimeUs = 1000000L * (totalBytesRead / 2) / SAMPLING_RATE;
                        }
                    }
                }

                // Drain audio
                int outputBufIndex = 0;
                while (outputBufIndex != MediaCodec.INFO_TRY_AGAIN_LATER) {
                    outputBufIndex = codec.dequeueOutputBuffer(outBuffInfo, CODEC_TIMEOUT_IN_MS);

                    if (outputBufIndex >= 0) {
                        ByteBuffer encodedData = codecOutputBuffers[outputBufIndex];
                        encodedData.position(outBuffInfo.offset);
                        encodedData.limit(outBuffInfo.offset + outBuffInfo.size);

                        if ((outBuffInfo.flags & MediaCodec.BUFFER_FLAG_CODEC_CONFIG) != 0 && outBuffInfo.size != 0) {
                            codec.releaseOutputBuffer(outputBufIndex, false);
                            continue; // Skip config buffer
                        } else {
                            mux.writeSampleData(audioTrackIdx, encodedData, outBuffInfo);
                            codec.releaseOutputBuffer(outputBufIndex, false);
                        }
                    } else if (outputBufIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED) {
                        outputFormat = codec.getOutputFormat();
                        Log.v(LOGTAG, "Output format changed - " + outputFormat);
                        audioTrackIdx = mux.addTrack(outputFormat);
                        mux.start();
                    } else if (outputBufIndex == MediaCodec.INFO_OUTPUT_BUFFERS_CHANGED) {
                        codecOutputBuffers = codec.getOutputBuffers(); // Update output buffers
                        Log.v(LOGTAG, "Output buffers changed.");
                    }
                }
            } while (outBuffInfo.flags != MediaCodec.BUFFER_FLAG_END_OF_STREAM);

            Log.v(LOGTAG, "Compression done ...");

        } catch (FileNotFoundException e) {
            Log.e(LOGTAG, "File not found!", e);
        } catch (IOException e) {
            Log.e(LOGTAG, "IO exception!", e);
        } finally {
            // Ensure the fis (InputStream) is closed
            try {
                if (fis != null) {
                    fis.close();
                }
            } catch (IOException e) {
                Log.e(LOGTAG, "Failed to close InputStream", e);
            }

            // Ensure the MediaCodec is released
            if (codec != null) {
                try {
                    codec.stop();
                } catch (IllegalStateException e) {
                    Log.e(LOGTAG, "Error stopping MediaCodec", e);
                }
                codec.release();
            }

            // Ensure the MediaMuxer is released
            if (mux != null) {
                try {
                    mux.stop();
                } catch (IllegalStateException e) {
                    Log.e(LOGTAG, "Error stopping MediaMuxer", e);
                }
                try {
                    mux.release();
                } catch (IllegalStateException e) {
                    Log.e(LOGTAG, "Error releasing MediaMuxer", e);
                }
            }
        }
    }
}
